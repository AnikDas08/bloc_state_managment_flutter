import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entity/dashboard_entity.dart';
import '../repository/home_repository.dart';

class GetDashboardUseCase {
  final HomeRepository repository;

  GetDashboardUseCase(this.repository);

  Future<Either<Failure, DashboardEntity>> call() async {
    return await repository.getDashboard();
  }
}
