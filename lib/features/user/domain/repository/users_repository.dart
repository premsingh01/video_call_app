import 'package:oxidized/oxidized.dart';
import 'package:video_call_app/features/user/domain/entity/users_entity.dart';

abstract class UsersRepository {
  Future<Result<UsersEntity, Err>> users();
}