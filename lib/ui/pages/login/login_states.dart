/// [LoginState] is an abstract class that represents the various states of the login process.
abstract class LoginState {}

/// [LoginInitial] represents the initial state when the login screen is first displayed.
class LoginInitial extends LoginState {}

/// [LoginLoading] represents the state when the login process is in progress.
class LoginLoading extends LoginState {}

/// [LoginSuccess] represents the state when the login process is successful.
class LoginSuccess extends LoginState {}

/// [LoginError] represents the state when an error occurs during the login process.
class LoginError extends LoginState {
  final String error;

  LoginError(this.error);
}
