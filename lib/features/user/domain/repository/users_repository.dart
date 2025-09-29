import 'package:video_call_app/features/user/domain/entity/users_entity.dart';

abstract class UsersRepository {
  Future<List<UsersEntity>> users();
}