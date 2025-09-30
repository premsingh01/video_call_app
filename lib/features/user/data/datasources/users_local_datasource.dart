import 'package:video_call_app/features/user/data/model/users_model.dart';
import 'package:video_call_app/features/user/domain/entity/users_entity.dart';
import 'package:video_call_app/local_database/dao/users_dao.dart';

abstract class UsersLocalDatasource {
  Future<UsersModel> getUsers();
  Future<void> saveUsers({required List<UserEntityDetail> usersList});
}


class UsersLocalDatasourceImpl implements UsersLocalDatasource {
  final UsersDao usersDao;
  UsersLocalDatasourceImpl({required this.usersDao});

  List<Map<String, dynamic>> _serialize(List<UserEntityDetail> usersList) {
    return usersList.map((json) {
      return {
        "id": json.id,
        "email": json.email,
        "first_name": json.firstName,
        "last_name": json.lastName,
        "avatar": json.avatar,
      };
    }).toList();
  }

  @override
  Future<UsersModel> getUsers() async {
    final rows = await usersDao.getUsers();
    Map<String, List<Map<String, dynamic>>> data = {};
    data["data"] = rows; 
    return UsersModel.fromJson(data);
  }

  @override
  Future<void> saveUsers({required List<UserEntityDetail> usersList}) async {
    final rows = _serialize(usersList);
    await usersDao.insertUsers(users: rows);
  }

}
