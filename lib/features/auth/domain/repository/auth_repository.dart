import 'package:video_call_app/features/auth/domain/entity/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity?> login({required String email, required String password});
}