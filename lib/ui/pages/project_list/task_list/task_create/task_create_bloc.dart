import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:flutter_crm_prove/data/repository/crm/crm_repository_response.dart';
import 'package:flutter_crm_prove/data/repository/task/task_repository.dart';
import 'package:flutter_crm_prove/domain/Task/task_formated.dart';
import 'package:flutter_crm_prove/domain/project/project_formated.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_create/task_create_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_create/task_create_states.dart';

import '../../../../../data/odoo_config.dart';
import '../../../../../domain/Task/task.dart';

class TaskCreateBloc extends Bloc<TaskCreateEvents, TaskCreateStates> {
  TaskCreateBloc() : super(TaskCreateInitial()) {
    odooClient.setSettings(OdooConfig.getBaseUrl(), OdooConfig.getSessionId());
    on<SetLoadingState>(setLoadingState);
    on<SetSuccessState>(setSuccessState);
    on<CreateEvent>(createTask);
  }

  OdooClient odooClient = OdooClient();
  late TaskRepository repository = TaskRepository(odooClient: odooClient);
  List<Task> tasks = [];

  setLoadingState(SetLoadingState state, Emitter<TaskCreateStates> emit) {
    try {
      emit(TaskCreateLoading());
    } catch (e) {
      emit(TaskCreateError("Error: $e"));
    }
  }

  setSuccessState(SetSuccessState state, Emitter<TaskCreateStates> emit) {
    try {
      emit(TaskCreateSuccess());
    } catch (e) {
      emit(TaskCreateError("Error: $e"));
    }
  }

  createTask(CreateEvent event, Emitter<TaskCreateStates> emit) async {
    emit(TaskCreateLoading());

    Map<String, dynamic> data = event.values;

    dynamic ids = await Future.wait([
      _getIdByNameOrNull('res.users', data['assigned_name']),
      _getIdByNameOrNull('res.company', data['company_names']),
      _getIdByNameOrNull('res.partner', data['client_name']),
      _getIdsByNames('project.tags', data['tag_names']),
      _getIdByNameOrNull('project.task.type', data['stage_names'])
    ]);

    data['assigned_ids'] = ids[0];
    if (data.containsKey('assigned_ids')) {
      data.remove('assigned_name');
    }

    data['company_id'] = ids[1] ?? null;
    if (data.containsKey('company_id')) {
      data.remove('company_names');
    }

    data['partner_id'] = ids[2];
    if (data.containsKey('partner_id')) {
      data.remove('client_name');
    }

    data['tag_ids'] = ids[3];
    if (data.containsKey('tag_ids')) {
      data.remove('tag_names');
    }

    data['stage_id'] = ids[4];
    if (data.containsKey('stage_id')) {
      data.remove('stage_names');
    }

    TaskFormated taskFormated = TaskFormated.fromJson(data);

    Task task = taskFormated.taskFormatedToTask(taskFormated);

    CreateResponse response = await repository.createTask('project.task', task.toJson(), event.projectId);

    if (response.success) {
      emit(TaskCreateSuccess());
    } else {
      emit(TaskCreateError("Ha ocurrido un error al crear la tarea"));
    }
  }

  Future<Map<String, List<String>>> getFieldsOptions() async {

    List<String> tagNames = await repository.getAllNames('project.tags', ['name']);
    List<String> stageNames = await repository.getAllNames('project.task.type', ['name']);
    List<String> assignedNames = await repository.getAllNames('res.users', ['name']);
    List<String> companyNames = await repository.getAllNames('res.company', ['name']);
    List<String> clientNames = await repository.getAllNames('res.partner', ['name']);

    Map<String, List<String>> fieldOptions = {
      'assigned_name': [],
      'client_name': [],
      'tag_names': [],
      'company_names': [],
      'stage_names': [],
    };

    fieldOptions['assigned_name'] = assignedNames;
    fieldOptions['client_name'] = clientNames;
    fieldOptions['tag_names'] = tagNames;
    fieldOptions['company_names'] = companyNames;
    fieldOptions['stage_names'] = stageNames;

    return fieldOptions;
  }

  /// [getIdByName] method to get id by name.
  Future<int?> _getIdByNameOrNull(String objectType, String? name) async {
    if (name == null) return null;
    if (name == 'Ninguno') return null;
    return repository.getIdByName(objectType, name);
  }

  /// [getIdsByNames] method to get ids by names.
  Future<List<int>> _getIdsByNames(String objectType, List<String>? names) async {
    if (names == null) return [];
    if (names.contains('Ninguno')) return [];
    var ids = await Future.wait(names.map((name) => repository.getIdByName(objectType, name)));
    return ids;
  }
}