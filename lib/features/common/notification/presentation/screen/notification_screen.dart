import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/model/notification_model.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../widgets/fcm_info_bottom_sheet.dart';
import '../widgets/notification_item_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: _buildAppBar(context),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading || state is NotificationInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2196F3)),
            );
          }

          if (state is NotificationFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48.sp,
                    color: const Color(0xFFFF5252),
                  ),
                  12.h.height,
                  Text(
                    'Failed to load notifications',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  8.h.height,
                  Text(
                    state.errorMessage,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.sp,
                      color: const Color(0xFF757575),
                    ),
                  ),
                  16.h.height,
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<NotificationBloc>()
                          .add(const InitializeNotifications());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Retry',
                      style: GoogleFonts.plusJakartaSans(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationActive) {
            final notifications = state.filteredNotifications;

            return Column(
              children: [
                // Filter Chip Bar
                _buildFilterChips(context, state),

                // Notifications Count Header Bar
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.activeFilter == 'All'
                            ? 'Recent Notifications'
                            : '${state.activeFilter} Notifications',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      Text(
                        '${notifications.length} item${notifications.length == 1 ? '' : 's'}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Notifications List / Empty State
                Expanded(
                  child: notifications.isEmpty
                      ? _buildEmptyState(context, state)
                      : ListView.builder(
                          padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
                          physics: const BouncingScrollPhysics(),
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final item = notifications[index];
                            return NotificationItemWidget(
                              item: item,
                              onTap: () => _handleItemTap(context, item),
                              onDelete: () {
                                context
                                    .read<NotificationBloc>()
                                    .add(DeleteNotification(item.id));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Notification deleted'),
                                    behavior: SnackBarBehavior.floating,
                                    action: SnackBarAction(
                                      label: 'Dismiss',
                                      onPressed: () {},
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ── App Bar ────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18.sp,
          color: const Color(0xFF1A1A2E),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          final unreadCount =
              (state is NotificationActive) ? state.unreadCount : 0;
          return Row(
            children: [
              Text(
                'Notifications',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF1A1A2E),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (unreadCount > 0) ...[
                8.w.width,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '$unreadCount new',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
      actions: [
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            final unreadCount =
                (state is NotificationActive) ? state.unreadCount : 0;
            return Tooltip(
              message: 'Mark all as read',
              child: IconButton(
                icon: Icon(
                  Icons.done_all_rounded,
                  size: 20.sp,
                  color: unreadCount > 0
                      ? const Color(0xFF2196F3)
                      : const Color(0xFFBDBDBD),
                ),
                onPressed: unreadCount > 0
                    ? () {
                        context
                            .read<NotificationBloc>()
                            .add(const MarkAllNotificationsAsRead());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All notifications marked as read'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    : null,
              ),
            );
          },
        ),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert_rounded,
            size: 20.sp,
            color: const Color(0xFF1A1A2E),
          ),
          onSelected: (value) {
            if (value == 'clear_all') {
              _confirmClearAll(context);
            } else if (value == 'fcm_info') {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const FcmInfoBottomSheet(),
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'fcm_info',
              child: Row(
                children: [
                  Icon(
                    Icons.bug_report_rounded,
                    size: 18.sp,
                    color: const Color(0xFF2196F3),
                  ),
                  10.w.width,
                  Text(
                    'FCM Debug Info',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'clear_all',
              child: Row(
                children: [
                  Icon(
                    Icons.clear_all_rounded,
                    size: 18.sp,
                    color: const Color(0xFFFF5252),
                  ),
                  10.w.width,
                  Text(
                    'Clear All',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFFF5252),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Filter Chips ───────────────────────────────────────────────────────
  Widget _buildFilterChips(BuildContext context, NotificationActive state) {
    final filterData = [
      {
        'label': 'All',
        'icon': Icons.all_inbox_rounded,
        'count': state.notifications.length,
      },
      {
        'label': 'Unread',
        'icon': Icons.mark_email_unread_rounded,
        'count': state.unreadCount,
      },
      {
        'label': 'Transactions',
        'icon': Icons.receipt_long_rounded,
        'count': state.notifications
            .where((n) => n.category == NotificationCategory.transaction)
            .length,
      },
      {
        'label': 'Promos',
        'icon': Icons.local_offer_rounded,
        'count': state.notifications
            .where((n) => n.category == NotificationCategory.coupon)
            .length,
      },
      {
        'label': 'System',
        'icon': Icons.circle_notifications_rounded,
        'count': state.notifications
            .where((n) => n.category == NotificationCategory.system)
            .length,
      },
      {
        'label': 'Security',
        'icon': Icons.shield_rounded,
        'count': state.notifications
            .where((n) => n.category == NotificationCategory.security)
            .length,
      },
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: SizedBox(
        height: 40.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: filterData.length,
          separatorBuilder: (_, _) => 10.w.width,
          itemBuilder: (context, index) {
            final data = filterData[index];
            final filter = data['label'] as String;
            final icon = data['icon'] as IconData;
            final count = data['count'] as int;
            final isSelected = state.activeFilter == filter;

            return GestureDetector(
              onTap: () {
                context
                    .read<NotificationBloc>()
                    .add(FilterNotifications(filter));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF1E88E5), Color(0xFF2196F3)],
                        )
                      : null,
                  color: isSelected ? null : const Color(0xFFF2F5F9),
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color:
                                const Color(0xFF2196F3).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 16.sp,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF64748B),
                    ),
                    6.w.width,
                    Text(
                      filter,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.sp,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF334155),
                      ),
                    ),
                    if (count > 0) ...[
                      6.w.width,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.25)
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          '$count',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Empty State Widget ─────────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context, NotificationActive state) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.notifications_off_rounded,
                  size: 38.sp,
                  color: const Color(0xFF2196F3),
                ),
              ),
            ),
            20.h.height,
            Text(
              'No Notifications Found',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            8.h.height,
            Text(
              state.activeFilter == 'All'
                  ? 'You are all caught up! No notifications available at the moment.'
                  : 'No notifications found under "${state.activeFilter}" filter.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.sp,
                color: const Color(0xFF757575),
                height: 1.4,
              ),
            ),
            24.h.height,
            if (state.activeFilter != 'All')
              OutlinedButton.icon(
                onPressed: () {
                  context
                      .read<NotificationBloc>()
                      .add(const FilterNotifications('All'));
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF2196F3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: Icon(Icons.filter_alt_off_rounded,
                    size: 16.sp, color: const Color(0xFF2196F3)),
                label: Text(
                  'Reset Filter',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2196F3),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Handle Tap Notification Item ───────────────────────────────────────
  void _handleItemTap(BuildContext context, NotificationModel item) {
    if (!item.isRead) {
      context.read<NotificationBloc>().add(MarkNotificationAsRead(item.id));
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 28.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            16.h.height,
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: item.category.backgroundColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    item.category.icon,
                    color: item.category.color,
                    size: 20.sp,
                  ),
                ),
                10.w.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.category.label,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: item.category.color,
                        ),
                      ),
                      Text(
                        item.timeAgo,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.sp,
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            16.h.height,
            Text(
              item.title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            10.h.height,
            Text(
              item.body,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.sp,
                color: const Color(0xFF424242),
                height: 1.4,
              ),
            ),
            24.h.height,
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Close',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Confirm Clear All ──────────────────────────────────────────────────
  void _confirmClearAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text(
          'Clear All Notifications?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'This action will remove all notifications from your list.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.sp,
            color: const Color(0xFF616161),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF757575),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context
                  .read<NotificationBloc>()
                  .add(const ClearAllNotifications());
            },
            child: Text(
              'Clear All',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFFF5252),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension _SizedBoxExtension on num {
  SizedBox get height => SizedBox(height: toDouble());
  SizedBox get width => SizedBox(width: toDouble());
}
