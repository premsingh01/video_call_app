import "package:get_it/get_it.dart";
import "package:video_call_app/features/auth/data/datasources/auth_remote_datasource.dart";
import "package:video_call_app/features/auth/data/repository_impl/auth_repository_impl.dart";
import "package:video_call_app/features/auth/domain/repository/auth_repository.dart";
import "package:video_call_app/features/auth/domain/usecase/auth_usecase.dart";
import "package:video_call_app/features/auth/presentation/bloc/auth_cubit.dart";
import "package:video_call_app/features/dashboard/presentation/bloc/dashboard_cubit.dart";

final sl = GetIt.instance;



void init() {

  sl.registerLazySingleton<AuthRemoteDatasource>(() => AuthRemoteDatasourceImpl());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(authRemoteDatasource: sl()));
  sl.registerLazySingleton(() => AuthUsecase(authRepository: sl()));

  sl.registerFactory<AuthCubit>(() => AuthCubit(authUsecase: sl()));
  sl.registerFactory<DashboardCubit>(() => DashboardCubit());
}