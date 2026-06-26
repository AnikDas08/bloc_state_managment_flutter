import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entity/receipt_entity.dart';

part 'receipt_details_state.dart';

class ReceiptDetailsCubit extends Cubit<ReceiptDetailsState> {
  ReceiptDetailsCubit() : super(ReceiptDetailsInitial());

  void loadReceiptDetails(ReceiptEntity receipt) {
    emit(ReceiptDetailsLoaded(receipt));
  }
}
