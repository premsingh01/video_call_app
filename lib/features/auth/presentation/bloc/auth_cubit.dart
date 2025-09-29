import 'package:bloc/bloc.dart';
import 'package:video_call_app/features/auth/domain/usecase/auth_usecase.dart';
import 'package:video_call_app/features/auth/presentation/bloc/auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  final AuthUsecase authUsecase;
  AuthCubit({required this.authUsecase}) : super(AuthInitialState()); 

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoadingState());
    final user = await authUsecase.call(email: email, password: password);
    if (user != null) {
      emit(AuthSuccessState(user.email));
    } else {
      emit(AuthFailureState("Invalid email or password"));
    }
  }
}