import 'package:equatable/equatable.dart';
import 'coupon_entity.dart';
import 'receipt_entity.dart';

class DashboardEntity extends Equatable {
  final String userName;
  final String totalManaged;
  final List<CouponEntity> coupons;
  final List<ReceiptEntity> recentArchives;



  const DashboardEntity({
    required this.userName,
    required this.totalManaged,
    required this.coupons,
    required this.recentArchives,
  });

  @override
  List<Object?> get props => [userName, totalManaged, coupons, recentArchives];
}
