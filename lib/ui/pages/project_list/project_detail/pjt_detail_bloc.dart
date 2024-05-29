import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:flutter_crm_prove/data/repository/project/pjt_repository.dart';
import 'package:flutter_crm_prove/domain/project/project.dart';
import 'package:flutter_crm_prove/domain/project/task.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_states.dart';

import '../../../../data/odoo_config.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvents, ProjectDetailStates> {
  ProjectDetailBloc() : super(ProjectDetailInitial()) {
    odooClient.setSettings(OdooConfig.getBaseUrl(), OdooConfig.getSessionId());
    on<SetState>(setState);
    on<LoadProject>(loadProject);
    on<ReloadDetail>(reloadProject);
    on<SaveProjectButtonPressed>(updateProject);
    on<NewProjectButtonPressed>(createProject);
    // on<DeleteProject>(deleteProject);
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

  updateProject(SaveProjectButtonPressed event, Emitter<ProjectDetailStates> emit) async {
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

  Future<List<String>> fetchProjectTaskStages() async {
    try {
      List<String> stages = (await projectRepository.getAllNames('project.task.type', ['id', 'name'])).cast<String>();
      return stages;
    } catch (e) {
      throw Exception('Failed to fetch lead statuses: $e');
    }
  }

  Future<Map<String, List<String>>> getDataList() async {
    try {
      List<String> tagNames = [];
      List<String> responsibles = [];
      List<String> projectStages = [];
      List<String> companyNames = [];
      List<String> clientNames = [];

      projectStages = (await projectRepository.getAllNames('project.project.stage', ['name'])).cast<String>();
      tagNames = (await projectRepository.getAllNames('mail.activity.type', ['name'])).cast<String>();
      responsibles = (await projectRepository.getAllNames('res.users', ['name'])).cast<String>();
      companyNames = (await projectRepository.getAllNames('res.company', ['name'])).cast<String>();
      clientNames = (await projectRepository.getAllNames('res.partner', ['name'])).cast<String>();

      Map<String, List<String>> dataList = {
        'tags': [],
        'responsible': [],
        'project_stage': [],
        'client': [],
        'company': [],
      };

      dataList['tags'] = tagNames;
      dataList['responsible'] = responsibles;
      dataList['project_stage'] = projectStages;
      dataList['client'] = clientNames;
      dataList['company'] = companyNames;

      return dataList;
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<List<Task>> tasks() async {
    try {
      List<Task> tasks = [];

      Map<String, dynamic> results = await projectRepository.getAll('project.task', [], ['project_id', '=', project.id]);

      tasks = results['records'].map<Task>((task) => Task.fromJson(task)).toList();
      return tasks;
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }
}