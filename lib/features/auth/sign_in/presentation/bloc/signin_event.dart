part of 'signin_bloc.dart';

@immutable
abstract class SignInEvent {}

class SignInSubmitted extends SignInEvent {
  final String email;
  final String password;
  final String role;

  SignInSubmitted({
    required this.email,
    required this.password,
    required this.role,
  });
}
