
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_list_page.dart';
import 'package:flutter_crm_prove/ui/pages/login/login_states.dart';

import '../../../data/repository.dart';
import 'login_events.dart';
import 'login_states.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(login);
  }
  Repository repository = Repository();

  login(LoginButtonPressed event, Emitter<LoginState> emit) async {
    if (event.url.isEmpty || event.username.isEmpty || event.password.isEmpty) {
      emit(LoginError('Todos los campos son obligatorios'));
      return;
    }

    try {
      final response = await repository.authenticate(event.url, 'demos_demos15', event.username, event.password);

      if (response.success) {
        emit(LoginSuccess());
      } else {
        emit(LoginError(response.errorMessage ?? 'Error desconocido'));
      }
    } catch (error) {
      emit(LoginError(error.toString()));
    }
  }
}