abstract class HomeState {}

class HomeInitial extends HomeState {}

class GetHomeSuccess extends HomeState {}

class GetHomeFailure extends HomeState {
  final String errorMessage;

  GetHomeFailure(this.errorMessage);
}

class GetUserSuccess extends HomeState {}

class GetUserFailure extends HomeState {
  final String errorMessage;

  GetUserFailure(this.errorMessage);
}

class LogOutSuccess extends HomeState {}

class LogOutFailure extends HomeState {
  final String errorMessage;

  LogOutFailure(this.errorMessage);
}

class ThemeChange extends HomeState {}


