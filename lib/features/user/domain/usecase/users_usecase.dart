import 'package:video_call_app/features/user/domain/entity/users_entity.dart';
import 'package:video_call_app/features/user/domain/repository/users_repository.dart';

class UsersUsecase {
  final UsersRepository usersRepository;
  const UsersUsecase({required this.usersRepository});

  Future<List<UsersEntity>> call() async {
    return usersRepository.users();
  }
}