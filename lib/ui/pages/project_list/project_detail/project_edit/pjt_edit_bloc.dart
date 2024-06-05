import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/project_edit/pjt_edit_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/project_edit/pjt_edit_states.dart';

import '../../../../../data/json/odoo_client.dart';
import '../../../../../data/odoo_config.dart';
import '../../../../../data/repository/project/pjt_repository.dart';
import '../../../../../domain/project/project.dart';

class ProjectEditBloc extends Bloc<ProjectEditEvent, ProjectEditStates> {
  ProjectEditBloc() : super(ProjectEditInitial()) {
    odooClient.setSettings(OdooConfig.getBaseUrl(), OdooConfig.getSessionId());
    on<SetState>(setState);
    // on<UpdateProject>(updateProject);
    on<StateSuccess>(setStateSucces);
  }

  OdooClient odooClient = OdooClient();
  late RepositoryProject projectRepository = RepositoryProject(odooClient: odooClient);
  Project project = Project(id: 0);

  setState(SetState state, Emitter emit) {
    try {
      emit(ProjectEditLoading());
      project = state.project;
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

  Future<int> getIdByName(String modelName, String name) async {
    try {
      return await projectRepository.getIdByName(modelName, name);
    } catch (e) {
      throw Exception('Failed to get id by name: $e');
    }
  }

  Future<String?> translateStage(int? stageId) async {
    if (stageId == null) return null;

    try {

      String? stageName = await projectRepository.getNameById('project.project.stage', stageId);

      if (stageName != null) {
        return stageName;
      }

      return null;
    } catch (e) {
      throw Exception('Failed to translate stage: $e');
    }
  }
}