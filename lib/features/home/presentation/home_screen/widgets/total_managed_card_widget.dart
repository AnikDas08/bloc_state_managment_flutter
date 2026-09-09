import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/extensions/extension.dart';
import '../bloc/home_bloc.dart';

class TotalManagedCardWidget extends StatelessWidget {
  final HomeLoaded state;

  const TotalManagedCardWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E88E5).withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with title & growth pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 16.sp,
                        color: const Color(0xFF2196F3),
                      ),
                    ),
                    8.w.width,
                    Text(
                      'Total Managed',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF616161),
                      ),
                    ),
                  ],
                ),
                // Growth Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C853).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up_rounded,
                        size: 14.sp,
                        color: const Color(0xFF00C853),
                      ),
                      4.w.width,
                      Text(
                        '+14.8%',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00C853),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            12.h.height,
            // Amount
            Text(
              state.dashboard.totalManaged,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 30.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E),
                letterSpacing: -0.5,
              ),
            ),
            16.h.height,
            const Divider(color: Color(0xFFF0F2F5), height: 1),
            14.h.height,
            // Footer row with avatars and receipt count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Stacked avatars
                    SizedBox(
                      width: 62.w,
                      height: 26.h,
                      child: Stack(
                        children: List.generate(3, (i) {
                          final colors = [
                            const Color(0xFF2196F3),
                            const Color(0xFFFF4081),
                            const Color(0xFF00E676),
                          ];
                          return Positioned(
                            left: (i * 16).toDouble(),
                            child: Container(
                              width: 26.w,
                              height: 26.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors[i],
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                size: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    6.w.width,
                    Text(
                      '+12 receipts this week',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.sp,
                  color: const Color(0xFFBDBDBD),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
