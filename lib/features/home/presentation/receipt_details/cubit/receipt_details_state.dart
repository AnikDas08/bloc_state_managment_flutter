part of 'receipt_details_cubit.dart';

abstract class ReceiptDetailsState extends Equatable {
  const ReceiptDetailsState();

  @override
  List<Object?> get props => [];
}

class ReceiptDetailsInitial extends ReceiptDetailsState {}

class ReceiptDetailsLoaded extends ReceiptDetailsState {
  final ReceiptEntity receipt;

  const ReceiptDetailsLoaded(this.receipt);

  @override
  List<Object?> get props => [receipt];
}
