/// [LoginEvent] is an abstract class that defines events related to login.
abstract class LoginEvent {}

/// [LoginButtonPressed] is an event triggered when the login button is pressed.
class LoginButtonPressed extends LoginEvent {
  final String url;
  final String username;
  final String password;

  LoginButtonPressed({required this.url, required this.username, required this.password});
}