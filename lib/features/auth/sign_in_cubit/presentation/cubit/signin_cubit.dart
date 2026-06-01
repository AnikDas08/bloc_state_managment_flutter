import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../sign_in/domain/repository/auth_repository.dart';
import 'signin_cubit_state.dart';

class SignInCubit extends Cubit<SignInCubitState> {
  final AuthRepository _authRepository;

  SignInCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignInCubitInitial());

  Future<void> signIn({
    required String email,
    required String password,
    required String role,
  }) async {
    emit(SignInCubitLoading());

    final result = await _authRepository.signIn(
      email: email,
      password: password,
      role: role,
    );
    result.fold(
      (failure) => emit(SignInCubitFailure(failure.message)),
      (user) => emit(SignInCubitSuccess(user)),
    );
  }
}
