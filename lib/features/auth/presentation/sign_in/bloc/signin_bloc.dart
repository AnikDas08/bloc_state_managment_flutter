import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/storage/storage_keys.dart';
import '../../../../../core/services/storage/storage_services.dart';
import '../../../domain/entity/user_entity.dart';
import '../../../domain/repository/auth_repository.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository _authRepository;

  SignInBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const SignInInitial()) {
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

    await result.fold(
      (failure) async => emit(SignInFailure(failure.message)),
      (user) async {
        // ── Persist user data to local storage ───────────────────────
        await _saveUserToLocalStorage(user);
        emit(SignInSuccess(user));
      },
    );
  }

  /// Saves token, id, name, email and role to SharedPreferences
  /// then refreshes the in-memory LocalStorage fields.
  Future<void> _saveUserToLocalStorage(UserEntity user) async {
    await LocalStorage.setString(LocalStorageKeys.token, user.accessToken);
    await LocalStorage.setString(LocalStorageKeys.userId, user.id);
    await LocalStorage.setString(LocalStorageKeys.myName, user.name);
    await LocalStorage.setString(LocalStorageKeys.myEmail, user.email);
    await LocalStorage.setString(LocalStorageKeys.myRole, user.role);
    await LocalStorage.setBool(LocalStorageKeys.isLogIn, true);

    // Refresh in-memory values so the rest of the app can read them immediately
    await LocalStorage.getAllPrefData();
  }
}
