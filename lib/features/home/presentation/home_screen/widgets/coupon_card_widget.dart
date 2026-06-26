import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/extensions/extension.dart';
import '../../../domain/entity/coupon_entity.dart';

class CouponCardWidget extends StatelessWidget {
  final CouponEntity coupon;
  const CouponCardWidget({super.key, required this.coupon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155.w,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category tag row
          Row(
            children: [
              Container(
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  color: coupon.categoryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Center(
                  child: Text(
                    coupon.categoryIcon,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              ),
              6.w.width,
              Text(
                coupon.category,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: coupon.categoryColor,
                ),
              ),
            ],
          ),
          10.h.height,
          // Offer title
          Text(
            coupon.title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
              height: 1.3,
            ),
          ),
          6.h.height,
          // Valid until
          Text(
            coupon.validUntil,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF979797),
            ),
          ),
          const Spacer(),
          // Arrow button
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.arrow_outward_rounded,
                size: 16.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
