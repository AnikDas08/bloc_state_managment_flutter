import 'package:equatable/equatable.dart';
import '../../../domain/entity/user_entity.dart';

abstract class SignInCubitState extends Equatable {
  const SignInCubitState();

  @override
  List<Object?> get props => [];
}

class SignInCubitInitial extends SignInCubitState {}

class SignInCubitLoading extends SignInCubitState {}

class SignInCubitSuccess extends SignInCubitState {
  final UserEntity user;
  const SignInCubitSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class SignInCubitFailure extends SignInCubitState {
  final String message;
  const SignInCubitFailure(this.message);

  @override
  List<Object?> get props => [message];
}
