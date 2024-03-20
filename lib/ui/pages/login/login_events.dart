abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String url;
  final String username;
  final String password;

  LoginButtonPressed({required this.url, required this.username, required this.password});
}