import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repository/auth_repository.dart';
import 'complete_profile_cubit_state.dart';

class CompleteProfileCubit extends Cubit<CompleteProfileCubitState> {
  final AuthRepository _authRepository;

  CompleteProfileCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(CompleteProfileCubitInitial());

  Future<void> completeProfile({
    required String name,
    required String email,
    required String phone,
    required String age,
  }) async {
    emit(CompleteProfileCubitLoading());

    final result = await _authRepository.completeProfile(
      name: name,
      email: email,
      phone: phone,
      age: age,
    );

    result.fold(
      (failure) => emit(CompleteProfileCubitFailure(failure.message)),
      (user) => emit(CompleteProfileCubitSuccess(user)),
    );
  }
}
