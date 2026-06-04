import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entity/coupon_entity.dart';
import '../domain/entity/receipt_entity.dart';

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
            name: 'Receipt 1',
            date: 'Created 12/02/2026',
            amount: 12.40,
            tag: 'FOOD & DRINK',
            totalQty: 8,
            items: 5,
          ),
          const ReceiptEntity(
            name: 'Receipt 1',
            date: 'Created 12/02/2026',
            amount: 12.40,
            tag: 'FOOD & DRINK',
            totalQty: 8,
            items: 5,
          ),
          const ReceiptEntity(
            name: 'Receipt 1',
            date: 'Created 12/02/2026',
            amount: 12.40,
            tag: 'FOOD & DRINK',
            totalQty: 8,
            items: 5,
          ),
        ],
      ),
    );
  }
}
