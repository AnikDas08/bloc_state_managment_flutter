import '../../../../core/services/api/api_service.dart';
import '../../../../config/api/api_end_point.dart';
import '../models/dashboard_model.dart';
import '../models/coupon_model.dart';
import '../models/receipt_model.dart';
import 'package:flutter/material.dart';

abstract class HomeRemoteDataSource {
  Future<DashboardModel> getDashboardData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<DashboardModel> getDashboardData() async {
    final response = await ApiService.get(ApiEndPoint.dashboard);

    if (response.statusCode == 200) {
      return DashboardModel.fromJson(response.data);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to load dashboard data');
    }
  }
}

// ── Mock Data Source (for UI and local testing) ──────────────────────────
class MockHomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  @override
  Future<DashboardModel> getDashboardData() async {
    // Simulated network latency
    await Future.delayed(const Duration(milliseconds: 500));
    
    return const DashboardModel(
      userName: 'Alex',
      totalManaged: '\$2,564.45',
      coupons: [
        CouponModel(
          category: 'Groceries',
          categoryIcon: '🛒',
          title: '10% OFF at Whole Foods',
          validUntil: 'Valid until November 28',
          categoryColor: Color(0xFFFF6B9D),
        ),
        CouponModel(
          category: 'Dining',
          categoryIcon: '🍽',
          title: '15% OFF at Pizza Hut',
          validUntil: 'Valid until December 05',
          categoryColor: Color(0xFF42A5F5),
        ),
      ],
      recentArchives: [
        ReceiptModel(
          name: 'Starbucks',
          date: 'October 23, 2025, 09:12 AM',
          amount: 1240.50,
          tag: 'FOOD & DRINK',
          totalQty: 3,
          items: 3,
        ),
        ReceiptModel(
          name: 'Apple Store',
          date: 'October 20, 2025',
          amount: 999.00,
          tag: 'ELECTRONICS',
          totalQty: 1,
          items: 1,
        ),
      ],
    );
  }
}
