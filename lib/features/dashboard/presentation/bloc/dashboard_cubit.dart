import 'package:bloc/bloc.dart';
import 'package:video_call_app/features/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitialState());

  void changeIndex({required int index}) {
    emit(DashboardSuccessState(index));
  }
}