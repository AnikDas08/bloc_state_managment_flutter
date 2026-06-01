import 'package:equatable/equatable.dart';
import '../../../domain/entity/user_entity.dart';

abstract class SignUpCubitState extends Equatable {
  const SignUpCubitState();

  @override
  List<Object?> get props => [];
}

class SignUpCubitInitial extends SignUpCubitState {}

class SignUpCubitLoading extends SignUpCubitState {}

class SignUpCubitSuccess extends SignUpCubitState {
  final UserEntity user;
  const SignUpCubitSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class SignUpCubitFailure extends SignUpCubitState {
  final String message;
  const SignUpCubitFailure(this.message);

  @override
  List<Object?> get props => [message];
}
