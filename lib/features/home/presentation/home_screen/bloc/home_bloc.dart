import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entity/coupon_entity.dart';
import '../../../domain/entity/receipt_entity.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeLoadDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
    HomeLoadDashboard event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    // Simulate a short network delay
    await Future.delayed(const Duration(milliseconds: 800));

    emit(
      HomeLoaded(
        userName: 'Alex',
        totalManaged: '\$2,564.45',
        coupons: [
          const CouponEntity(
            category: 'Groceries',
            categoryIcon: '🛒',
            title: '10% OFF at Whole Foods',
            validUntil: 'Valid until November 28',
            categoryColor: Color(0xFFFF6B9D),
          ),
          const CouponEntity(
            category: 'Dining',
            categoryIcon: '🍽',
            title: '10% OFF at Whole Foods',
            validUntil: 'Valid until November 28',
            categoryColor: Color(0xFF42A5F5),
          ),
        ],
        recentArchives: [
          const ReceiptEntity(
            name: 'Starbucks',
            date: 'October 23, 2025, 09:12 AM',
            amount: 1240.50,
            tag: 'FOOD & DRINK',
            totalQty: 3,
            items: 3,
            category: 'Merchant',
            referenceNumber: '#APL - 987657',
            subtotal: 1240.50,
            tax: 0.0,
            imageUrl:
                'https://i.pinimg.com/736x/8e/3c/6f/8e3c6f8f8f8f8f8f8f8f8f8f8f8f8f8f.jpg', // Placeholder for receipt image
            breakdownItems: [
              ReceiptBreakdownItemEntity(
                title: 'Bespoke Design System Consulting',
                description: 'Tier 3 Audit + Implementation',
                price: 850.00,
                quantity: 1,
              ),
              ReceiptBreakdownItemEntity(
                title: 'Annual Hosting License',
                description: 'Enterprise Cloud Cluster',
                price: 350.00,
                quantity: 1,
              ),
              ReceiptBreakdownItemEntity(
                title: 'Premium Support Add-on',
                description: '24/7 Slack Connect',
                price: 40.50,
                quantity: 1,
              ),
            ],
          ),
          const ReceiptEntity(
            name: 'Apple Store',
            date: 'October 20, 2025',
            amount: 999.00,
            tag: 'ELECTRONICS',
            totalQty: 1,
            items: 1,
          ),
        ],
      ),
    );
  }
}
