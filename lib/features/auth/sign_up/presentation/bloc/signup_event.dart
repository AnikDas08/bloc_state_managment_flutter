part of 'signup_bloc.dart';

@immutable
abstract class SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final String name;
  final String email;
  final String password;
  final String role;

  SignUpSubmitted({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}
