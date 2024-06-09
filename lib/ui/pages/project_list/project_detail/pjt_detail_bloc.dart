import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:flutter_crm_prove/data/repository/project/pjt_repository.dart';
import 'package:flutter_crm_prove/data/repository/task/task_repository.dart';
import 'package:flutter_crm_prove/domain/Task/task_formated.dart';
import 'package:flutter_crm_prove/domain/project/project.dart';
import 'package:flutter_crm_prove/domain/Task/task.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_states.dart';

import '../../../../data/odoo_config.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvents, ProjectDetailStates> {
  ProjectDetailBloc() : super(ProjectDetailInitial()) {
    odooClient.setSettings(OdooConfig.getBaseUrl(), OdooConfig.getSessionId());
    on<SetState>(setState);
    on<SetSuccessState>(setSuccessState);
    on<ChangeFilter>(changeFilter);
    on<LoadProject>(loadProject);
    on<ReloadDetail>(reloadProject);
    on<SaveProjectButtonPressed>(updateProject);
    on<NewTaskButtonPressed>(createTask);
    on<TaskSelected>(selectTask);
    // on<DeleteProject>(deleteProject);
  }

  OdooClient odooClient = OdooClient();
  late RepositoryProject projectRepository = RepositoryProject(odooClient: odooClient);
  late TaskRepository taskRepository = TaskRepository(odooClient: odooClient);
  Project project = Project(id: 0);
  List<Task> tasksL = [];
  bool isEditing = false;

  setState(SetState event, Emitter<ProjectDetailStates> emit) {
    try {
      emit(ProjectDetailLoading());
    } catch (e) {
      emit(ProjectDetailError());
    }
  }

  changeFilter(ChangeFilter event, Emitter<ProjectDetailStates> emit) async {
    try {
      emit(ProjectDetailLoading());

      String? filter = event.filter;
      int? stageId = await projectRepository.getStageIdByName('project.task.type', event.filter, project.typeIds ?? []);
      List<Task> filteredTasks = tasksL.where((task) => task.stageId == stageId).toList();

      Map<String, dynamic> data = {'tasks': filteredTasks};

      emit(ProjectDetailSort(filter, data));
    } catch (e) {
      emit(ProjectDetailError());
    }
  }

  setSuccessState(SetSuccessState event, Emitter<ProjectDetailStates> emit) {
    try {
      emit(ProjectDetailSuccess(project));
    } catch (e) {
      emit(ProjectDetailError());
    }
  }

  selectTask(TaskSelected event, Emitter<ProjectDetailStates> emit) {
    try {
      emit(ProjectDetailLoading());

      emit(TaskDetail(event.task));
    } catch (e) {
      emit(ProjectDetailError());
    }
  }

  loadProject(LoadProject event, Emitter<ProjectDetailStates> emit) {
    try {
      emit(ProjectDetailLoading());

     project = event.project;

      emit(ProjectDetailLoaded(project));
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

  createTask(NewTaskButtonPressed event, Emitter<ProjectDetailStates> emit) async {
    try {
      emit(ProjectDetailLoading());
      emit(TaskNew());
    } catch (e) {
      emit(ProjectDetailError());
    }
  }

  Future<List<TaskFormated>> getTaskFormated(List<Task> tasks) async {
    try {
      List<TaskFormated> tasksFormated = [];

      for (var task in tasks) {
        List<Future> futures = [
          taskRepository.getNamesByIds('res.partner', task.assignedIds),
          taskRepository.getNameById('res.partner', task.clientId ?? 0),
          taskRepository.getNamesByIds('project.tags', task.tagIds),
          taskRepository.getNameById('res.company', task.companyId ?? 0),
          taskRepository.getNameById('project.task.type', task.stageId ?? 0),
        ];

        List results = await Future.wait(futures);

        List<String> assignedNames = results[0];
        String clientName = results[1];
        List<String> tagNames = results[2];
        String companyName = results[3];
        String stageName = results[4];

        TaskFormated taskFormated = TaskFormated(
          id: task.id,
          name: task.name,
          description: task.description,
          assignedIds: task.assignedIds,
          assignedNames: assignedNames,
          clientId: task.clientId,
          clientName: clientName,
          dateEnd: task.dateEnd,
          tagIds: task.tagIds,
          tagNames: tagNames,
          companyId: task.companyId,
          companyName: companyName,
          plannedHours: task.plannedHours,
          stageId: task.stageId,
          stageName: stageName,
          priority: task.priority,
          totalHoursSpent: task.totalHoursSpent,
          remainingHours: task.remainingHours,
        );

        tasksFormated.add(taskFormated);
      }

      return tasksFormated;
    } catch (e) {
      throw Exception('Failed to get task formatted: $e');
    }
  }


  Future<List<String>> fetchProjectTaskStages() async {
    try {
      var domain = [
        'project_ids', 'in', project.id,
      ];
      Map<String, dynamic> stages = await projectRepository.getAll('project.task.type', ['id', 'name'], domain);

      List<dynamic> stageRecords = stages['records'];
      List<String> stageNames = stageRecords.map<String>((stage) => stage['name'] as String).toList();
      return stageNames;
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
      tagNames = (await projectRepository.getAllNames('project.tags', ['name'])).cast<String>();
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
      tasksL = [];

      Map<String, dynamic> results = await projectRepository.getAll('project.task', [], ['project_id', '=', project.id]);

      tasksL = results['records'].map<Task>((task) => Task.fromJson(task)).toList();
      return tasksL;
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }
}