import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entity/user_entity.dart';
import '../../../domain/repository/auth_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository _authRepository;

  SignUpBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(SignUpLoading());
    final result = await _authRepository.signUp(
      name: event.name,
      email: event.email,
      password: event.password,
      role: event.role,
    );

    result.fold(
      (failure) => emit(SignUpFailure(failure.message)),
      (user) => emit(SignUpSuccess(user)),
    );
  }
}
