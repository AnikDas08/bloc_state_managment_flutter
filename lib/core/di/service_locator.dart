import 'package:get_it/get_it.dart';
import '../../features/auth/data/data_source/auth_remote_data_source.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/presentation/sign_in/bloc/signin_bloc.dart';
import '../../features/auth/presentation/sign_in_cubit/cubit/signin_cubit.dart';
import '../../features/auth/presentation/sign_up/bloc/signup_bloc.dart';
import '../../features/auth/presentation/sign_up_cubit/cubit/signup_cubit.dart';
import '../../features/auth/presentation/compl_profile/bloc/complete_profile_bloc.dart';
import '../../features/counter/data/counter_repository.dart';
import '../../features/counter/bloc/counter_bloc.dart';
import '../../features/home/bloc/home_bloc.dart';

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
  sl.registerFactory(() => HomeBloc());
}
