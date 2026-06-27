import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entity/dashboard_entity.dart';
import '../../../domain/usecase/get_dashboard_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetDashboardUseCase getDashboardUseCase;

  HomeBloc({required this.getDashboardUseCase}) : super(HomeInitial()) {
    on<HomeLoadDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(
    HomeLoadDashboard event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    final result = await getDashboardUseCase();

    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (dashboard) => emit(HomeLoaded(dashboard: dashboard)),
    );
  }
}
