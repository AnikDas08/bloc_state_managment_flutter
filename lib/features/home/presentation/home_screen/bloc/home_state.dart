part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final DashboardEntity dashboard;

  HomeLoaded({required this.dashboard});
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
