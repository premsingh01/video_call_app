import 'package:oxidized/oxidized.dart';
import 'package:video_call_app/core/utils/check_network_utility.dart';
import 'package:video_call_app/features/user/data/datasources/users_local_datasource.dart';
import 'package:video_call_app/features/user/data/datasources/users_remote_datasource.dart';
import 'package:video_call_app/features/user/domain/entity/users_entity.dart';
import 'package:video_call_app/features/user/domain/repository/users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDatasource usersRemoteDatasource;
  final UsersLocalDatasource usersLocalDatasource;
  final CheckNetworkUtility checkNetworkUtility;

  const UsersRepositoryImpl({
    required this.usersRemoteDatasource,
    required this.usersLocalDatasource,
    required this.checkNetworkUtility,
  });

  @override
  Future<Result<UsersEntity, Err>> users() async {
    final hasNet = await checkNetworkUtility.hasNetwork();

    if (hasNet) {
      // Try remote API
      final remoteResult = await Result.asyncOf<UsersEntity, Err>(() => usersRemoteDatasource.getUsers());
      if(remoteResult.isOk()) {
        return remoteResult;
      }

      // if (remoteResult.isOk()) {
      //   // Cache for offline use, then return
      //   final movies = remoteResult.unwrap();
      //   // Persist latest fetched list locally for offline usage
      //   await localDatasource.saveMovies(movies);
      //   return Result.ok(movies);
      // }
    }

    // If no internet or remote failed → fallback to local DB
    final localResult = await Result.asyncOf<UsersEntity, Err>(() => usersLocalDatasource.getUsers());
    return localResult;
  }
}
