import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../sign_in/domain/entity/user_entity.dart';
import '../../../sign_in/domain/repository/auth_repository.dart';

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
    
    // Here you would typically call a repository method for complete profile.
    // For now, I'll add a dummy delay to show the loading state working.
    await Future.delayed(const Duration(seconds: 2));
    
    // emit(CompleteProfileSuccess(...)); 
    // or
    // emit(CompleteProfileFailure("Error message"));
  }
}
