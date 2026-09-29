import '../../domain/entity/dashboard_entity.dart';
import 'coupon_model.dart';
import 'receipt_model.dart';

class DashboardModel extends DashboardEntity {
  const DashboardModel({
    required super.userName,
    required super.totalManaged,
    required super.coupons,
    required super.recentArchives,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      userName: json['user_name'] ?? '',
      totalManaged: json['total_managed'] ?? '',
      coupons: (json['coupons'] as List?)
              ?.map((e) => CouponModel.fromJson(e))
              .toList() ??
          [],
      recentArchives: (json['recent_archives'] as List?)
              ?.map((e) => ReceiptModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
