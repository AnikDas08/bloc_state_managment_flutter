import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entity/dashboard_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../datasource/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardEntity>> getDashboard() async {
    try {
      final dashboard = await remoteDataSource.getDashboardData();
      return Right(dashboard);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
