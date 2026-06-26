part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String userName;
  final String totalManaged;
  final List<CouponEntity> coupons;
  final List<ReceiptEntity> recentArchives;

  HomeLoaded({
    required this.userName,
    required this.totalManaged,
    required this.coupons,
    required this.recentArchives,
  });
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
