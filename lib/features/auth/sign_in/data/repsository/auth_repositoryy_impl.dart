// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  // ইন্টারফেসের পরিবর্তে সরাসরি আমাদের সিঙ্গেল ক্লাস টাইপটি ব্যবহার করা হচ্ছে
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      // সরাসরি সিঙ্গেল ক্লাসের মেথড কল করা হলো
      final userModel = await remoteDataSource.signIn(
        email: email,
        password: password,
        role: role,
      );

      // ডাটা সোর্স থেকে UserModel (যা UserEntity কে এক্সটেন্ড করে) সফলভাবে আসলে Right বক্সে রিটার্ন হবে
      return Right(userModel);
    } catch (e) {
      // এপিআই বা ডাটা সোর্সে কোনো এরর (Exception) থ্রো হলে তা ক্যাচ করে Left বক্সে পাঠানো হবে
      // e.toString() থেকে নোংরা "Exception: " লেখাটি মুছে ক্লিন মেসেজ দেওয়া হচ্ছে
      final cleanMessage = e.toString().replaceAll("Exception: ", "");
      return Left(ServerFailure(cleanMessage));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final userModel = await remoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      return Right(userModel);
    } catch (e) {
      final cleanMessage = e.toString().replaceAll("Exception: ", "");
      return Left(ServerFailure(cleanMessage));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> completeProfile({
    required String name,
    required String email,
    required String phone,
    required int age
  }) async {
    try {
      final userModel = await remoteDataSource.completeProfile(
        name: name,
        email: email,
        phone: phone,
        age: age,
      );
      return Right(userModel);
    } catch (e) {
      final cleanMessage = e.toString().replaceAll("Exception: ", "");
      return Left(ServerFailure(cleanMessage));
    }
  }
}
