import 'package:equatable/equatable.dart';

class ReceiptEntity extends Equatable {
  final String name;
  final String date;
  final double amount;
  final String tag;
  final int totalQty;
  final int items;
  final String? imageUrl;
  final String? category;
  final String? referenceNumber;
  final double? subtotal;
  final double? tax;
  final List<ReceiptBreakdownItemEntity>? breakdownItems;

  const ReceiptEntity({
    required this.name,
    required this.date,
    required this.amount,
    required this.tag,
    required this.totalQty,
    required this.items,
    this.imageUrl,
    this.category,
    this.referenceNumber,
    this.subtotal,
    this.tax,
    this.breakdownItems,
  });

  @override
  List<Object?> get props => [
        name,
        date,
        amount,
        tag,
        totalQty,
        items,
        imageUrl,
        category,
        referenceNumber,
        subtotal,
        tax,
        breakdownItems,
      ];
}

class ReceiptBreakdownItemEntity extends Equatable {
  final String title;
  final String description;
  final double price;
  final int quantity;

  const ReceiptBreakdownItemEntity({
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
  });

  @override
  List<Object?> get props => [title, description, price, quantity];
}
