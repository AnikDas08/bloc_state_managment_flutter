import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entity/dashboard_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, DashboardEntity>> getDashboard();
}
