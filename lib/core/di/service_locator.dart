import 'package:get_it/get_it.dart';
import '../../features/auth/sign_in/data/data_source/data_source.dart';
import '../../features/auth/sign_in/data/repsository/auth_repositoryy_impl.dart';
import '../../features/auth/sign_in/domain/repository/auth_repository.dart';
import '../../features/auth/sign_in/presentation/bloc/signin_bloc.dart';
import '../../features/auth/sign_in_cubit/presentation/cubit/signin_cubit.dart';
import '../../features/auth/sign_up/presentation/bloc/signup_bloc.dart';
import '../../features/auth/sign_up_cubit/presentation/cubit/signup_cubit.dart';
import '../../features/auth/compl_profile/presentation/bloc/complete_profile_bloc.dart';
import '../../features/counter/data/counter_repository.dart';
import '../../features/counter/bloc/counter_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());

  // Repositories
  sl.registerLazySingleton<CounterRepository>(() => CounterRepository());
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Blocs
  sl.registerFactory(() => CounterBloc(repository: sl()));
  sl.registerFactory(() => SignInBloc(authRepository: sl()));
  sl.registerFactory(() => SignInCubit(authRepository: sl()));
  sl.registerFactory(() => SignUpBloc(authRepository: sl()));
  sl.registerFactory(() => SignUpCubit(authRepository: sl()));
  sl.registerFactory(() => CompleteProfileBloc(authRepository: sl()));
}
