import 'package:fpdart/fpdart.dart';

import '../../../../../core/error/failure.dart';
import '../entity/user_entity.dart';


abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
    required String role,
  });

  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  });

  Future<Either<Failure, UserEntity>> completeProfile({
    required String name,
    required String email,
    required String phone,
    required int age
  });
}