import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entity/user_entity.dart';
import '../../../domain/repository/auth_repository.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository _authRepository;

  SignInBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignInInitial()) {
    on<SignInSubmitted>(_onSignInSubmitted);
  }

  Future<void> _onSignInSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInLoading());
    final result = await _authRepository.signIn(
      email: event.email,
      password: event.password,
      role: event.role,
    );

    result.fold(
      (failure) => emit(SignInFailure(failure.message)),
      (user) => emit(SignInSuccess(user)),
    );
  }
}
