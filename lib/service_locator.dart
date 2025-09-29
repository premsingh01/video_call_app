import "package:get_it/get_it.dart";
import "package:video_call_app/core/network/api_client.dart";
import "package:video_call_app/core/utils/check_network_utility.dart";
import "package:video_call_app/features/auth/data/datasources/auth_remote_datasource.dart";
import "package:video_call_app/features/auth/data/repository_impl/auth_repository_impl.dart";
import "package:video_call_app/features/auth/domain/repository/auth_repository.dart";
import "package:video_call_app/features/auth/domain/usecase/auth_usecase.dart";
import "package:video_call_app/features/auth/presentation/bloc/auth_cubit.dart";
import "package:video_call_app/features/dashboard/presentation/bloc/dashboard_cubit.dart";
import "package:video_call_app/features/user/data/datasources/users_local_datasource.dart";
import "package:video_call_app/features/user/data/datasources/users_remote_datasource.dart";
import "package:video_call_app/features/user/data/repository_impl/users_repository_impl.dart";
import "package:video_call_app/features/user/domain/repository/users_repository.dart";
import "package:video_call_app/features/user/domain/usecase/users_usecase.dart";
import "package:video_call_app/features/user/presentation/bloc/users_cubit.dart";

final sl = GetIt.instance;



void init() {
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  sl.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasourceImpl(apiClient: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(authRemoteDatasource: sl()));
  sl.registerLazySingleton(() => AuthUsecase(authRepository: sl()));

  sl.registerFactory<AuthCubit>(() => AuthCubit(authUsecase: sl()));
  sl.registerFactory<DashboardCubit>(() => DashboardCubit());

  sl.registerLazySingleton<CheckNetworkUtility>(() => CheckNetworkUtility());
  sl.registerLazySingleton<UsersRemoteDatasource>(() => UsersRemoteDatasourceImpl(apiClient: sl()));
  sl.registerLazySingleton<UsersLocalDatasource>(() => UsersLocalDatasourceImpl());
  sl.registerLazySingleton<UsersRepository>(() => UsersRepositoryImpl(usersRemoteDatasource: sl(), usersLocalDatasource: sl(), checkNetworkUtility: sl()));
  sl.registerLazySingleton(() => UsersUsecase(usersRepository: sl()));
  sl.registerFactory<UsersCubit>(() => UsersCubit(usersUsecase: sl()));

}