import 'package:get_it/get_it.dart';
import '../../features/common/auth/data/data_source/auth_remote_data_source.dart';
import '../../features/common/auth/data/repository/auth_repository_impl.dart';
import '../../features/common/auth/domain/repository/auth_repository.dart';
import '../../features/common/auth/presentation/compl_profile/bloc/complete_profile_bloc.dart';
import '../../features/common/auth/presentation/compl_profile_cubit/cubit/complete_profile_cubit.dart';
import '../../features/common/auth/presentation/sign_in/bloc/signin_bloc.dart';
import '../../features/common/auth/presentation/sign_in_cubit/cubit/signin_cubit.dart';
import '../../features/common/auth/presentation/sign_up/bloc/signup_bloc.dart';
import '../../features/common/auth/presentation/sign_up_cubit/cubit/signup_cubit.dart';
import '../../features/common/notification/presentation/bloc/notification_bloc.dart';
import '../../features/role/user/home/data/datasource/home_remote_data_source.dart';
import '../../features/role/user/home/data/repository/home_repository_impl.dart';
import '../../features/role/user/home/domain/repository/home_repository.dart';
import '../../features/role/user/home/domain/usecase/get_dashboard_usecase.dart';
import '../../features/role/user/home/presentation/home_screen/bloc/home_bloc.dart';
import '../../features/role/user/home/presentation/receipt_details/cubit/receipt_details_cubit.dart';
import '../services/notification/notification_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => MockHomeRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<NotificationService>(() => NotificationService());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetDashboardUseCase(sl()));

  // Blocs & Cubits
  sl.registerFactory(() => SignInBloc(authRepository: sl()));
  sl.registerFactory(() => SignInCubit(authRepository: sl()));
  sl.registerFactory(() => SignUpBloc(authRepository: sl()));
  sl.registerFactory(() => SignUpCubit(authRepository: sl()));
  sl.registerFactory(() => CompleteProfileBloc(authRepository: sl()));
  sl.registerFactory(() => CompleteProfileCubit(authRepository: sl()));
  sl.registerFactory(() => HomeBloc(getDashboardUseCase: sl()));
  sl.registerFactory(() => ReceiptDetailsCubit());
  sl.registerFactory(() => NotificationBloc(notificationService: sl()));
}
