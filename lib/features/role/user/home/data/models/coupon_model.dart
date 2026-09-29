import 'package:flutter/material.dart';
import '../../domain/entity/coupon_entity.dart';

class CouponModel extends CouponEntity {
  const CouponModel({
    required super.category,
    required super.categoryIcon,
    required super.title,
    required super.validUntil,
    required super.categoryColor,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      category: json['category'] ?? '',
      categoryIcon: json['category_icon'] ?? '',
      title: json['title'] ?? '',
      validUntil: json['valid_until'] ?? '',
      categoryColor: Color(int.parse(json['category_color'] ?? '0xFF2196F3')),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'category_icon': categoryIcon,
      'title': title,
      'valid_until': validUntil,
      'category_color': '0x${categoryColor.value.toRadixString(16).toUpperCase()}',
    };
  }
}
