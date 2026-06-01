part of 'complete_profile_bloc.dart';

@immutable
abstract class CompleteProfileState {}

class CompleteProfileInitial extends CompleteProfileState {}

class CompleteProfileLoading extends CompleteProfileState {}

class CompleteProfileSuccess extends CompleteProfileState {
  final UserEntity user;
  CompleteProfileSuccess(this.user);
}

class CompleteProfileFailure extends CompleteProfileState {
  final String message;
  CompleteProfileFailure(this.message);
}
