import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/project_edit/pjt_edit_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/project_edit/pjt_edit_states.dart';

class ProjectEditBloc extends Bloc<ProjectEditEvent, ProjectEditStates> {
  ProjectEditBloc() : super(ProjectEditInitial()) {
    on<SetState>(setState);
    // on<UpdateProject>(updateProject);
    on<StateSuccess>(setStateSucces);
  }

  setState(SetState state, Emitter emit) {
    try {
      emit(ProjectEditLoading());
    } catch (e) {
      emit(ProjectEditError('Error'));
    }
  }

  setStateSucces(StateSuccess state, Emitter emit) {
    try {
      emit(ProjectEditSuccess());
    } catch (e) {
      emit(ProjectEditError('Error'));
    }
  }

  updateProject(UpdatePjt state, Emitter emit) {
    try {
      // emit(ProjectEditUpdate(state.data));


    } catch (e) {
      emit(ProjectEditError('Error'));
    }
  }
}