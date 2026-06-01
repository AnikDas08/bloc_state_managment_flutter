import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String accessToken;
  final String phone;
  final int age;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.accessToken,
    required this.phone,
    required this.age
  });

  @override
  List<Object?> get props => [id, name, email, role, accessToken];
}