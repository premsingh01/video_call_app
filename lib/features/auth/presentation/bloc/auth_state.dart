


sealed class AuthState {}

class AuthInitialState implements AuthState {}

class AuthLoadingState implements AuthState {}

class AuthSuccessState implements AuthState {
  final String email;
  AuthSuccessState(this.email);
}

class AuthFailureState implements AuthState {
  final String message;
  AuthFailureState(this.message);
}
