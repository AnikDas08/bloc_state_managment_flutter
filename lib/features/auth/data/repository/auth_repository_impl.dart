import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entity/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final userModel = await remoteDataSource.signIn(
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
    required int age,
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
