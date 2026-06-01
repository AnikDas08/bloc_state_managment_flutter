import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../sign_in/domain/repository/auth_repository.dart';
import 'signup_cubit_state.dart';

class SignUpCubit extends Cubit<SignUpCubitState> {
  final AuthRepository _authRepository;

  SignUpCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignUpCubitInitial());

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    emit(SignUpCubitLoading());

    final result = await _authRepository.signUp(
      name: name,
      email: email,
      password: password,
      role: role,
    );

    result.fold(
      (failure) => emit(SignUpCubitFailure(failure.message)),
      (user) => emit(SignUpCubitSuccess(user)),
    );
  }
}
