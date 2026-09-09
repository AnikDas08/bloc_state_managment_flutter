import '../../../../config/api/api_end_point.dart';
import '../../../../core/services/api/api_service.dart';
import '../model/user_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource();

  Future<UserModel> signIn({
    required String email,
    required String password,
    required String role,
  }) async {
    final Map<String, String> body = {
      "email": email,
      "password": password,
      "role": role,
    };

    final response = await ApiService.post(
      ApiEndPoint.signIn,
      body: body,
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception(response.message ?? "Login failed!");
    }
  }

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final Map<String, String> body = {
      "name": name,
      "email": email,
      "password": password,
      "role": role,
    };

    final response = await ApiService.post(
      ApiEndPoint.signUp,
      body: body,
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception(response.message ?? "Sign up failed!");
    }
  }

  Future<UserModel> completeProfile({
    required String name,
    required String email,
    required String phone,
    required int age,
  }) async {
    final Map<String, dynamic> body = {
      "name": name,
      "email": email,
      "phone": phone,
      "age": age,
    };
    final response = await ApiService.post(
      ApiEndPoint.completeProfile,
      body: body,
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 201 || response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception(response.message ?? "Complete profile failed!");
    }
  }
}
