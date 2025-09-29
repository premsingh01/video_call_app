import 'package:video_call_app/features/auth/domain/entity/auth_entity.dart';
import 'package:video_call_app/features/auth/domain/repository/auth_repository.dart';

class AuthUsecase {
  final AuthRepository authRepository;
  AuthUsecase({required this.authRepository});

  Future<AuthEntity?> call({required String email, required String password}) async {
    return authRepository.login(email: email, password: password);
  }
}