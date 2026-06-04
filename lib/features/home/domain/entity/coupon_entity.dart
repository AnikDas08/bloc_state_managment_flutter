import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CouponEntity extends Equatable {
  final String category;
  final String categoryIcon;
  final String title;
  final String validUntil;
  final Color categoryColor;

  const CouponEntity({
    required this.category,
    required this.categoryIcon,
    required this.title,
    required this.validUntil,
    required this.categoryColor,
  });

  @override
  List<Object?> get props => [category, title, validUntil];
}
