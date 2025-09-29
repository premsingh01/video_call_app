import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_call_app/features/user/presentation/bloc/users_cubit.dart';
import 'package:video_call_app/features/user/presentation/bloc/users_state.dart';
import 'package:video_call_app/service_locator.dart';



class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: BlocProvider(
        create: (_) => sl<UsersCubit>()..users(),
        child: BlocBuilder<UsersCubit, UsersState>(
          builder: (context, state) {
            switch (state) {
              case UsersInitialState():
                return SizedBox.shrink();
              case UsersLoadingState():
                return Center(child: CircularProgressIndicator());
              case UsersSuccessState():
                return Text("${state.usersList.length}");
              case UsersFailureState():
                return Center(child: SizedBox.shrink(child: Text(state.message),));
            }
          }),
         ),
    );
  }
}