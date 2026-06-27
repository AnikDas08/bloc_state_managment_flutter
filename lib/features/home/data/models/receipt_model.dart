import '../../domain/entity/receipt_entity.dart';

class ReceiptModel extends ReceiptEntity {
  const ReceiptModel({
    required super.name,
    required super.date,
    required super.amount,
    required super.tag,
    required super.totalQty,
    required super.items,
    super.imageUrl,
    super.category,
    super.referenceNumber,
    super.subtotal,
    super.tax,
    super.breakdownItems,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    return ReceiptModel(
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      tag: json['tag'] ?? '',
      totalQty: json['total_qty'] ?? 0,
      items: json['items'] ?? 0,
      imageUrl: json['image_url'],
      category: json['category'],
      referenceNumber: json['reference_number'],
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      breakdownItems: (json['breakdown_items'] as List?)
          ?.map((e) => ReceiptBreakdownItemModel.fromJson(e))
          .toList(),
    );
  }
}

class ReceiptBreakdownItemModel extends ReceiptBreakdownItemEntity {
  const ReceiptBreakdownItemModel({
    required super.title,
    required super.description,
    required super.price,
    required super.quantity,
  });

  factory ReceiptBreakdownItemModel.fromJson(Map<String, dynamic> json) {
    return ReceiptBreakdownItemModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
    );
  }
}
