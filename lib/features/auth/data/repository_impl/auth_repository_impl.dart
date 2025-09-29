import 'package:video_call_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:video_call_app/features/auth/data/model/auth_model.dart';
import 'package:video_call_app/features/auth/domain/entity/auth_entity.dart';
import 'package:video_call_app/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;
  AuthRepositoryImpl({required this.authRemoteDatasource});

  @override
  Future<AuthEntity?> login({required String email, required String password}) async {
    bool isValidLogin = await authRemoteDatasource.login(email: email, password: password);
    if (isValidLogin) {
      return AuthModel(email: email);
    } else {
      return null; // invalid credentials
    }
  
  }
}