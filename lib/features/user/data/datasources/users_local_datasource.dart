import 'package:video_call_app/features/user/data/model/users_model.dart';

abstract class UsersLocalDatasource {
  Future<UsersModel> getUsers();
}


class UsersLocalDatasourceImpl implements UsersLocalDatasource {

  @override
  Future<UsersModel> getUsers() async {
    // final result = UsersModel.fromJson(response.data);
    return UsersModel();
  }

}
