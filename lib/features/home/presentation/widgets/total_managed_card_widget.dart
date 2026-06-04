import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/extensions/extension.dart';
import '../../bloc/home_bloc.dart';

class TotalManagedCardWidget extends StatelessWidget {
  final HomeLoaded state;
  const TotalManagedCardWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Managed',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2196F3),
              ),
            ),
            6.h.height,
            Text(
              state.totalManaged,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            12.h.height,
            Row(
              children: [
                // Stacked avatars
                SizedBox(
                  width: 60.w,
                  height: 24.h,
                  child: Stack(
                    children: List.generate(3, (i) {
                      final colors = [
                        const Color(0xFF2196F3),
                        const Color(0xFFFF6B9D),
                        const Color(0xFF66BB6A),
                      ];
                      return Positioned(
                        left: (i * 16).toDouble(),
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors[i],
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                8.w.width,
                Text(
                  '+12 receipts this week',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF979797),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
