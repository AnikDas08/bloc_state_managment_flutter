import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../utils/extensions/extension.dart';
import '../../../../../component/text/common_text.dart';
import '../bloc/home_bloc.dart';

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
            CommonText(
              text: 'Total Managed',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2196F3),
              textAlign: TextAlign.start,
            ),
            6.h.height,
            CommonText(
              text: state.dashboard.totalManaged,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A2E),
              textAlign: TextAlign.start,
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
                CommonText(
                  text: '+12 receipts this week',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF979797),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
