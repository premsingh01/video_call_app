import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_call_app/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:video_call_app/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:video_call_app/features/user/presentation/page/user_view.dart';
import 'package:video_call_app/features/videocall/presentation/page/videocall_view.dart';
import 'package:video_call_app/service_locator.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {

  final List<Widget> _pages = [
    VideocallView(),
    const UserView(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardCubit>()..changeIndex(index: 0),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          switch (state) {
            case DashboardInitialState():
              return const SizedBox.shrink();
            case DashboardLoadingState():
              return const SizedBox.shrink();
            case DashboardSuccessState():
              return Scaffold(
                body: _pages.elementAt(state.index), //IndexedStack(index: state.index, children: _pages),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: state.index,
                  selectedItemColor: Colors.red,
                  onTap: (index) {
                    context.read<DashboardCubit>().changeIndex(index: index);
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.video_call),
                      label: "Videocall",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: "Users",
                    ),
                  ],
                ),
              );
            case DashboardFailureState():
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
