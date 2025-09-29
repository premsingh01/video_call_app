


sealed class DashboardState {}

class DashboardInitialState implements DashboardState {}

class DashboardLoadingState implements DashboardState {}

class DashboardSuccessState implements DashboardState {
  final int index;
  DashboardSuccessState(this.index);
}

class DashboardFailureState implements DashboardState {}