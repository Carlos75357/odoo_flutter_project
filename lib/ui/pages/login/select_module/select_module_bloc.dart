import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/ui/pages/login/select_module/select_module_events.dart';
import 'package:flutter_crm_prove/ui/pages/login/select_module/select_module_states.dart';

class ModuleBloc extends Bloc<ModuleEvent, ModuleState> {
  ModuleBloc() : super(ModuleStateInitial()) {
    on<ModuleEventButtonPressed>(moduleSelected);
  }

  moduleSelected(ModuleEventButtonPressed event, Emitter<ModuleState> emit) {
    emit(ModuleStateLoading());

    if (event.id != 0 && event.id != 1 || event.id == null) {
      emit(ModuleStateError("Hay un error con el ID del modulo."));
    } else {
      emit(ModuleStateSuccess(event.id));
    }
  }
}