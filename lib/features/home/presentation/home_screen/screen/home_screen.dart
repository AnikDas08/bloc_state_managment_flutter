import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../utils/extensions/extension.dart';
import '../../../../../../core/di/service_locator.dart';
import '../../../domain/entity/coupon_entity.dart';
import '../../receipt_details/widgets/receipt_item_widget.dart';
import '../bloc/home_bloc.dart';
import '../widgets/coupon_card_widget.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/total_managed_card_widget.dart';

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

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      floatingActionButton: _buildFAB(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2196F3)),
            );
          }
          if (state is HomeError) {
            return Center(child: Text(state.message));
          }
          if (state is HomeLoaded) {
            return _buildBody(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, HomeLoaded state) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Blue Header ──────────────────────────────────────────────────
        SliverToBoxAdapter(
            child: Column(
              children: [
                HomeHeaderWidget(state: state),
              ],
            )
        ),

        SliverToBoxAdapter(
          child: Transform.translate(
            offset: Offset(0, -0.h),
            child: TotalManagedCardWidget(state: state),
          ),
        ),


        // ── Curated Coupons section Sheader ────────────────────────────────
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: Offset(0, -0.h),
            child: _buildSectionHeader('Curated Coupons', 'View All'),
          ),
        ),

        // ── Coupons horizontal list ───────────────────────────────────────
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: Offset(0, -0.h),
            child: _buildCouponsRow(state.coupons),
          ),
        ),

        // ── Recent Archives header ────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 8.h,
              bottom: 12.h,
            ),
            child: Text(
              'Recent Archives',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ),
        ),

        // ── Recent Archives list ──────────────────────────────────────────
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                ReceiptItemWidget(receipt: state.recentArchives[index]),
            childCount: state.recentArchives.length,
          ),
        ),

        SliverToBoxAdapter(child: 100.h.height),
      ],
    );
  }

  // ── Section header ────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, String actionLabel) {
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
          Row(
            children: [
              Text(
                actionLabel,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2196F3),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18.sp,
                color: const Color(0xFF2196F3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Coupons horizontal list ───────────────────────────────────────────
  Widget _buildCouponsRow(List<CouponEntity> coupons) {
    return SizedBox(
      height: 160.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: coupons.length,
        separatorBuilder: (_, __) => 12.w.width,
        itemBuilder: (_, i) => CouponCardWidget(coupon: coupons[i]),
      ),
    );
  }

  // ── Floating Action Button ────────────────────────────────────────────
  Widget _buildFAB() {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 24.sp),
    );
  }
}
