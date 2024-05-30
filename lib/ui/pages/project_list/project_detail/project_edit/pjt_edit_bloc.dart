import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/project_edit/pjt_edit_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/project_edit/pjt_edit_states.dart';

class ProjectEditBloc extends Bloc<ProjectEditEvent, ProjectEditState> {
  ProjectEditBloc() : super(ProjectEditInitial()) {
    on<SetState>((event, emit) {
      emit(ProjectEditSuccess());
    });
  }

  setState(ProjectEditLoading state, Emitter emit) {
    try {
      emit(ProjectEditLoading());
    } catch (e) {
      emit(ProjectEditError('Error'));
    }
  }

  updateProject(ProjectEditUpdate state, Emitter emit) {
    try {
      emit(ProjectEditUpdate(state.data));


    } catch (e) {
      emit(ProjectEditError('Error'));
    }
  }
}