import 'package:video_call_app/features/user/domain/entity/users_entity.dart';

sealed class UsersState {}


class UsersInitialState implements UsersState {}

class UsersLoadingState implements UsersState {}

class UsersSuccessState implements UsersState {
  final List<UsersEntity> usersList;
  UsersSuccessState({required this.usersList});
}

class UsersFailureState implements UsersState {
  final String message;
  UsersFailureState({required this.message});
}