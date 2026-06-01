import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entity/user_entity.dart';
import '../../../domain/repository/auth_repository.dart';

part 'complete_profile_event.dart';
part 'complete_profile_state.dart';

class CompleteProfileBloc extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  final AuthRepository _authRepository;

  CompleteProfileBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(CompleteProfileInitial()) {
    on<CompleteProfileData>(_onCompleteProfileData);
  }

  Future<void> _onCompleteProfileData(
      CompleteProfileData event,
      Emitter<CompleteProfileState> emit,
      ) async {
    emit(CompleteProfileLoading());
    
    final result = await _authRepository.completeProfile(
      name: event.name,
      email: event.email,
      phone: event.phone,
      age: event.age,
    );

    result.fold(
      (failure) => emit(CompleteProfileFailure(failure.message)),
      (user) => emit(CompleteProfileSuccess(user)),
    );
  }
}
