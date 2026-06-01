import '../../domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.accessToken,
    required super.phone,
    required super.age
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return UserModel(
      id: data['_id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      accessToken: data['accessToken'] ?? '',
      phone: data['phone'] ?? '',
      age: data['age'] ?? 0,
    );
  }
}
