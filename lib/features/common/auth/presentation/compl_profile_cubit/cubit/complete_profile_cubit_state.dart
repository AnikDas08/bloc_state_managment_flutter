import 'package:equatable/equatable.dart';
import '../../../domain/entity/user_entity.dart';

abstract class CompleteProfileCubitState extends Equatable {
  const CompleteProfileCubitState();

  @override
  List<Object?> get props => [];
}

class CompleteProfileCubitInitial extends CompleteProfileCubitState {}

class CompleteProfileCubitLoading extends CompleteProfileCubitState {}

class CompleteProfileCubitSuccess extends CompleteProfileCubitState {
  final UserEntity user;
  const CompleteProfileCubitSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class CompleteProfileCubitFailure extends CompleteProfileCubitState {
  final String message;
  const CompleteProfileCubitFailure(this.message);

  @override
  List<Object?> get props => [message];
}
