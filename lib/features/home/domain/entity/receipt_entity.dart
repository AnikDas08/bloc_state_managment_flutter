import 'package:equatable/equatable.dart';

class ReceiptEntity extends Equatable {
  final String name;
  final String date;
  final double amount;
  final String tag;
  final int totalQty;
  final int items;

  const ReceiptEntity({
    required this.name,
    required this.date,
    required this.amount,
    required this.tag,
    required this.totalQty,
    required this.items,
  });

  @override
  List<Object?> get props => [name, date, amount, tag];
}
