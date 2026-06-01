part of 'signup_bloc.dart';

@immutable
abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final UserEntity user;
  SignUpSuccess(this.user);
}

class SignUpFailure extends SignUpState {
  final String message;
  SignUpFailure(this.message);
}
