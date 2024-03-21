import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/login/login_states.dart';

import '../../../data/repository.dart';
import 'login_events.dart';

/// LoginBloc class, for login events and states, using flutter_bloc package
/// controll login events and states.
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(login);
  }
  Repository repository = Repository();
  /// login event, for login button check if all fields are not empty, if there
  /// is some empty field return a LoginError state.
  login(LoginButtonPressed event, Emitter<LoginState> emit) async {
    if (event.url.isEmpty || event.url.trim() == 'https://'  || event.username.isEmpty || event.password.isEmpty) {
      emit(LoginError('Todos los campos son obligatorios'));
      return;
    }
    /// Login request, try to authenticate with the provided credentials, if the
    /// credentials are correct, return a LoginSuccess state, otherwise return a
    /// LoginError state.
    try {
      final response = await repository.authenticate(event.url, 'demos_demos15', event.username, event.password);

      if (response.success) {
        emit(LoginSuccess());
      } else {
        emit(LoginError('Credenciales incorrectas'));
      }
    } catch (error) {
      emit(LoginError('Algo falló durante la autenticación'));
    }
  }
}