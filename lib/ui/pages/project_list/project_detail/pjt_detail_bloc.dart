import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:flutter_crm_prove/data/repository/project/pjt_repository.dart';
import 'package:flutter_crm_prove/domain/project/project.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_states.dart';

import '../../../../data/odoo_config.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvents, ProjectDetailStates> {
  ProjectDetailBloc() : super(ProjectDetailInitial()) {
    odooClient.setSettings(OdooConfig.getBaseUrl(), OdooConfig.getSessionId());
    on<SetState>(setState);
    on<LoadProject>(loadProject);
    on<ReloadDetail>(reloadProject);
  }

  OdooClient odooClient = OdooClient();
  late RepositoryProject projectRepository = RepositoryProject(odooClient: odooClient);
  Project project = Project(id: 0);
  bool isEditing = false;

  setState(SetState event, Emitter<ProjectDetailStates> emit) {
    try {
      emit(ProjectDetailLoading());
    } catch (e) {
      emit(ProjectDetailError());
    }
  }

  loadProject(LoadProject event, Emitter<ProjectDetailStates> emit) {
    try {
      emit(ProjectDetailLoading());

     project = event.project;

      emit(ProjectDetailSuccess(project));
    } catch (e) {
      emit(ProjectDetailError());
    }
  }

  reloadProject(ReloadDetail event, Emitter<ProjectDetailStates> emit) async {
    try {
      emit(ProjectDetailLoading());

      project = await projectRepository.listProject('project.project', event.id);

      emit(ProjectReloaded(project));
    } catch (e) {
      emit(ProjectDetailError());
    }
  }

  updateProject(SaveLeadButtonPressed event, Emitter<ProjectDetailStates> emit) async {
    try {
      emit(ProjectDetailLoading());

      Project projectChanged = Project.fromJson(event.changes);

      var response = await projectRepository.updateProject('project.project', project.id, projectChanged);

      if (response.success) {
        var responseProject = await projectRepository.listProject('project.project', project.id);

        emit(ProjectReloaded(responseProject));
      }
    } catch (e) {
      emit(ProjectDetailError());
    }
  }

  createProject(NewProjectButtonPressed event, Emitter<ProjectDetailStates> emit) async {
    try {
      emit(ProjectDetailLoading());
      emit(ProjectNew());
    } catch (e) {
      emit(ProjectDetailError());
    }
  }

  Future<List<String>> fetchProjectStages() async {
    try {
      List<String> stages = (await projectRepository.getAllNames('crm.stage', ['id', 'name'])).cast<String>();
      return stages;
    } catch (e) {
      throw Exception('Failed to fetch lead statuses: $e');
    }
  }
}