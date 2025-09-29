
abstract class AuthRemoteDatasource {
  Future<bool> login({required String email, required String password});
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {

  final _mockEmail = 'test@example.com';
  final _mockPassword = 'password123';

  @override
  Future<bool> login({required String email, required String password}) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay
    if (email == _mockEmail && password == _mockPassword) {
      return true;
    } else {
      return false; // invalid credentials
    }
}
}