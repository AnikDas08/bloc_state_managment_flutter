import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../utils/extensions/extension.dart';
import '../../../../../../core/di/service_locator.dart';
import '../../../../../../component/text/common_text.dart';
import '../../../domain/entity/coupon_entity.dart';
import '../../../domain/entity/receipt_entity.dart';
import '../../receipt_details/widgets/receipt_item_widget.dart';
import '../bloc/home_bloc.dart';
import '../widgets/coupon_card_widget.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/total_managed_card_widget.dart';
import '../../../../notification/presentation/bloc/notification_bloc.dart';
import '../../../../notification/presentation/bloc/notification_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(HomeLoadDashboard()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listenWhen: (previous, current) {
        if (previous is NotificationActive && current is NotificationActive) {
          return previous.lastReceivedMessage != current.lastReceivedMessage ||
              previous.lastClickedMessage != current.lastClickedMessage;
        }
        return current is NotificationActive;
      },
      listener: (context, state) {
        if (state is NotificationActive) {
          if (state.lastReceivedMessage != null) {
            final notification = state.lastReceivedMessage!.notification;
            if (notification != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Notification Received: ${notification.title}\n${notification.body}',
                  ),
                  backgroundColor: const Color(0xFF2196F3),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 4),
                ),
              );
            }
          }

          if (state.lastClickedMessage != null) {
            final notification = state.lastClickedMessage!.notification;
            final title = notification?.title ?? 'Notification Clicked';
            final body = notification?.body ?? 'Payload: ${state.lastClickedMessage!.data}';

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(title),
                content: Text(body),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FC),
        floatingActionButton: _buildFAB(context),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF2196F3)),
              );
            }
            if (state is HomeError) {
              return Center(child: CommonText(text: state.message));
            }
            if (state is HomeLoaded) {
              return _buildBody(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeLoaded state) {
    final filteredArchives = state.dashboard.recentArchives.where((receipt) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return receipt.name.toLowerCase().contains(q) ||
          receipt.tag.toLowerCase().contains(q);
    }).toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Header Widget ────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: HomeHeaderWidget(
            state: state,
            onSearchChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
        ),

        // ── Total Managed Card (Overlapping) ─────────────────────────────
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: Offset(0, -28.h),
            child: TotalManagedCardWidget(state: state),
          ),
        ),

        // ── Quick Actions Grid ───────────────────────────────────────────
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: Offset(0, -12.h),
            child: _buildQuickActions(),
          ),
        ),

        // ── Curated Coupons Section Header ──────────────────────────────
        SliverToBoxAdapter(
          child: _buildSectionHeader(
            'Curated Coupons',
            'View All',
            onActionTap: () {},
          ),
        ),

        // ── Coupons Horizontal List ─────────────────────────────────────
        SliverToBoxAdapter(
          child: _buildCouponsRow(state.dashboard.coupons),
        ),

        16.h.height.toSliverBox,

        // ── Recent Archives Header ──────────────────────────────────────
        SliverToBoxAdapter(
          child: _buildSectionHeader(
            'Recent Archives',
            'Filter',
            icon: Icons.tune_rounded,
            onActionTap: () {},
          ),
        ),

        // ── Recent Archives List ────────────────────────────────────────
        filteredArchives.isEmpty
            ? SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Center(
                    child: Text(
                      'No matching archives found.',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF9E9E9E),
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      ReceiptItemWidget(receipt: filteredArchives[index]),
                  childCount: filteredArchives.length,
                ),
              ),

        SliverToBoxAdapter(child: 90.h.height),
      ],
    );
  }

  // ── Quick Actions Row ──────────────────────────────────────────────────
  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.qr_code_scanner_rounded, 'label': 'Scan', 'color': const Color(0xFF2196F3)},
      {'icon': Icons.local_offer_rounded, 'label': 'Coupons', 'color': const Color(0xFFFF9800)},
      {'icon': Icons.bar_chart_rounded, 'label': 'Analytics', 'color': const Color(0xFF9C27B0)},
      {'icon': Icons.file_download_rounded, 'label': 'Export', 'color': const Color(0xFF00C853)},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.map((action) {
          final color = action['color'] as Color;
          return Column(
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    action['icon'] as IconData,
                    color: color,
                    size: 24.sp,
                  ),
                ),
              ),
              6.h.height,
              Text(
                action['label'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF424242),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // ── Section Header ────────────────────────────────────────────────────
  Widget _buildSectionHeader(
    String title,
    String actionLabel, {
    IconData icon = Icons.chevron_right_rounded,
    VoidCallback? onActionTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          InkWell(
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  Text(
                    actionLabel,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2196F3),
                    ),
                  ),
                  2.w.width,
                  Icon(
                    icon,
                    size: 16.sp,
                    color: const Color(0xFF2196F3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Coupons Horizontal List ───────────────────────────────────────────
  Widget _buildCouponsRow(List<CouponEntity> coupons) {
    return SizedBox(
      height: 165.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: coupons.length,
        separatorBuilder: (_, _) => 12.w.width,
        itemBuilder: (_, i) => CouponCardWidget(coupon: coupons[i]),
      ),
    );
  }

  // ── Floating Action Button ────────────────────────────────────────────
  Widget _buildFAB(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF2196F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(30.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.qr_code_scanner_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
                8.w.width,
                Text(
                  'Scan Receipt',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension _SliverBoxExtension on Widget {
  Widget get toSliverBox => SliverToBoxAdapter(child: this);
}
