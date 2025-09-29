import 'package:video_call_app/core/network/api_client.dart';
import 'package:video_call_app/features/user/data/model/users_model.dart';

abstract class UsersRemoteDatasource {
  Future<UsersModel> getUsers();
}


class UsersRemoteDatasourceImpl implements UsersRemoteDatasource {
  final ApiClient apiClient;
  const UsersRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<UsersModel> getUsers() async {
    final response = await apiClient.dio.get('users?page=1');
    final result = UsersModel.fromJson(response.data);
    return result;
  }
}