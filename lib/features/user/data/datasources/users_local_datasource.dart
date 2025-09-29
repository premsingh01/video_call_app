import 'package:video_call_app/features/user/data/model/users_model.dart';

abstract class UsersLocalDatasource {
  Future<List<UsersModel>> getUsers();
}


class UsersLocalDatasourceImpl implements UsersLocalDatasource {

  @override
  Future<List<UsersModel>> getUsers() async {
    return [UsersModel(id: null, name: "", avatar: "")];
  }

}
