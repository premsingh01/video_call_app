import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_call_app/features/user/domain/usecase/users_usecase.dart';
import 'package:video_call_app/features/user/presentation/bloc/users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UsersUsecase usersUsecase;
  UsersCubit({required this.usersUsecase}) : super(UsersInitialState());

  Future<void> users() async {
    emit(UsersLoadingState());
    final results = await usersUsecase();
    results.when(
      ok: (p0) => emit(UsersSuccessState(usersList: p0.data ?? [])),
      err: (err) => emit(UsersFailureState(message: err.toString())));
  }
}