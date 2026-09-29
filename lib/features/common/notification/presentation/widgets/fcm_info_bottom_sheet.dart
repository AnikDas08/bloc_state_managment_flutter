import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';

class FcmInfoBottomSheet extends StatelessWidget {
  const FcmInfoBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          final fcmToken =
              (state is NotificationActive) ? state.fcmToken : 'Loading...';
          final hasPermission =
              (state is NotificationActive) ? state.hasPermission : false;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle indicator
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
                  Icon(
                    Icons.notifications_active_rounded,
                    color: const Color(0xFF2196F3),
                    size: 24.sp,
                  ),
                  10.w.width,
                  Text(
                    'Push Notification Debug Info',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
              16.h.height,
              // Permission Status
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: hasPermission
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: hasPermission
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFFF5252),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      hasPermission
                          ? Icons.check_circle_rounded
                          : Icons.cancel_rounded,
                      color: hasPermission
                          ? const Color(0xFF2E7D32)
                          : const Color(0xFFC62828),
                      size: 20.sp,
                    ),
                    10.w.width,
                    Text(
                      hasPermission
                          ? 'Push Notification Permission Granted'
                          : 'Push Notification Permission Denied',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: hasPermission
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFC62828),
                      ),
                    ),
                  ],
                ),
              ),
              16.h.height,
              Text(
                'FCM Registration Token',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF757575),
                ),
              ),
              6.h.height,
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        fcmToken ?? 'Token Unavailable',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.sp,
                          color: const Color(0xFF424242),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (fcmToken != null) ...[
                      8.w.width,
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: fcmToken));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('FCM Token copied to clipboard!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.copy_rounded,
                          size: 18.sp,
                          color: const Color(0xFF2196F3),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              20.h.height,
              // Test Local Notification Button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Simulate receiving a live notification
                    final now = DateTime.now();
                    context.read<NotificationBloc>().add(
                          MarkNotificationAsRead(
                              now.millisecondsSinceEpoch.toString()),
                        );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Simulated live notification trigger!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(Icons.send_rounded, size: 18.sp, color: Colors.white),
                  label: Text(
                    'Trigger Test Alert',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

extension _SizedBoxExtension on num {
  SizedBox get height => SizedBox(height: toDouble());
  SizedBox get width => SizedBox(width: toDouble());
}
