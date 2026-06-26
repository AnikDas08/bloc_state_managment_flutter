import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/extensions/extension.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../domain/entity/receipt_entity.dart';
import '../cubit/receipt_details_cubit.dart';

class ReceiptDetailsScreen extends StatelessWidget {
  final ReceiptEntity receipt;

  const ReceiptDetailsScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReceiptDetailsCubit>()..loadReceiptDetails(receipt),
      child: const ReceiptDetailsView(),
    );
  }
}

class ReceiptDetailsView extends StatelessWidget {
  const ReceiptDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Light blue background from image
      body: BlocBuilder<ReceiptDetailsCubit, ReceiptDetailsState>(
        builder: (context, state) {
          if (state is ReceiptDetailsLoaded) {
            final receipt = state.receipt;
            return SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        children: [
                          20.h.height,
                          _buildReceiptImage(receipt.imageUrl),
                          24.h.height,
                          _buildMerchantCard(receipt),
                          20.h.height,
                          _buildDateTimeSection(receipt),
                          24.h.height,
                          _buildBreakdownCard(receipt),
                          30.h.height,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                color: const Color(0xFF2196F3),
                size: 24.sp,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Receipt Details',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ),
          ),
          44.w.width, // Balance for the back button
        ],
      ),
    );
  }

  Widget _buildReceiptImage(String? imageUrl) {
    return Container(
      height: 300.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        image: DecorationImage(
          image: NetworkImage(imageUrl ?? 'https://via.placeholder.com/400x600'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchantCard(ReceiptEntity receipt) {
    return Row(
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            image: const DecorationImage(
              image: NetworkImage('https://via.placeholder.com/100'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        12.w.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                receipt.name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              Text(
                receipt.category ?? 'Merchant',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF979797),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFFB3E5FC),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            receipt.tag,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0288D1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSection(ReceiptEntity receipt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoColumn('DATE', receipt.date),
        _buildInfoColumn('REFERENCE', receipt.referenceNumber ?? '#APL - 987657'),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF979797),
            letterSpacing: 0.5,
          ),
        ),
        4.h.height,
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF5C5C5C),
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownCard(ReceiptEntity receipt) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PURCHASE BREAKDOWN',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF979797),
              letterSpacing: 0.5,
            ),
          ),
          16.h.height,
          if (receipt.breakdownItems != null)
            ...receipt.breakdownItems!.map((item) => _buildBreakdownItem(item)),
          20.h.height,
          _buildDashedLine(),
          20.h.height,
          _buildPriceRow('Subtotal', '\$${(receipt.subtotal ?? receipt.amount).toStringAsFixed(2)}'),
          8.h.height,
          _buildPriceRow('Tax (0%)', '\$${(receipt.tax ?? 0.0).toStringAsFixed(2)}'),
          24.h.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Paid',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              Text(
                '\$${receipt.amount.toStringAsFixed(2)}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(ReceiptBreakdownItemEntity item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                Text(
                  item.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF979797),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${item.price.toStringAsFixed(2)}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              Text(
                'Qty: ${item.quantity}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF979797),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF979797),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }

  Widget _buildDashedLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey.shade300),
              ),
            );
          }),
        );
      },
    );
  }
}
