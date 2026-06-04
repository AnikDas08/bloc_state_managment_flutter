import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/extensions/extension.dart';
import '../../domain/entity/receipt_entity.dart';

class ReceiptItemWidget extends StatelessWidget {
  final ReceiptEntity receipt;
  const ReceiptItemWidget({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Receipt thumbnail
          Container(
            width: 50.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F8),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 28.sp,
                  color: const Color(0xFF2196F3),
                ),
                Positioned(
                  bottom: 4.h,
                  child: Container(
                    width: 30.w,
                    height: 2.h,
                    color: const Color(0xFF2196F3).withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
          12.w.width,
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + Amount row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      receipt.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    Text(
                      '\$${receipt.amount.toStringAsFixed(2)}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2196F3),
                      ),
                    ),
                  ],
                ),
                4.h.height,
                // Date
                Text(
                  receipt.date,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF979797),
                  ),
                ),
                8.h.height,
                // Tag + qty + items + arrow
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEECC),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        receipt.tag,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFE65100),
                        ),
                      ),
                    ),
                    8.w.width,
                    Text(
                      'Total Qty: ${receipt.totalQty}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF979797),
                      ),
                    ),
                    6.w.width,
                    Text(
                      'Items: ${receipt.items}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF979797),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18.sp,
                      color: const Color(0xFF979797),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
