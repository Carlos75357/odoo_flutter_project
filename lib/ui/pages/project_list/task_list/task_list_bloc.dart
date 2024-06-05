import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/data/repository/task/task_repository.dart';
import 'package:flutter_crm_prove/domain/project/project.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_list_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_list_states.dart';

import '../../../../data/json/odoo_client.dart';
import '../../../../data/odoo_config.dart';
import '../../../../domain/Task/task.dart';

class TaskListBloc extends Bloc<TaskListEvents, TaskListStates> {
  TaskListBloc() : super(TaskListInitial()) {
    on<TaskListEvents>((event, emit) {
      odooClient.setSettings(OdooConfig.getBaseUrl(), OdooConfig.getSessionId());
      // TODO: implement event handler
    });
  }

  OdooClient odooClient = OdooClient();
  late TaskRepository taskRepository = TaskRepository(odooClient: odooClient);
  List<Task> tasks = [];

  listTasks(TaskListLoad event, Emitter<TaskListStates> emit) async {
    try {
      emit(TaskListLoading());
      final response = await taskRepository.listTasks('project.task', [["project_id", "=", 1]], {});
      tasks = response;
      Map<String, dynamic> result = {
        "tasks": tasks
      };
      emit(TaskListSuccess(result));
    } catch (e) {
      emit(TaskListError(e.toString()));
    }
  }

  selectTask(TaskSelected event, Emitter<TaskListStates> emit) {
    try {
      emit(TaskListLoading());

      emit(TaskListDetail(event.task));
    } catch (e) {
      emit(TaskListError(e.toString()));
    }
  }

  newTask(TaskListNewButtonPressed event, Emitter<TaskListStates> emit) {
    try {
      emit(TaskListLoading());
      emit(TaskListNew());
    } catch (e) {
      emit(TaskListError(e.toString()));
    }

  }

  reloadAll(TaskListReloadEvent event, Emitter<TaskListStates> emit) async {
    try {
      emit(TaskListLoading());

      final response = await taskRepository.listTasks('project.task', [["project_id", "=", 1]], {});

      tasks = response;
      Map<String, dynamic> result = {
        "tasks": tasks
      };
      emit(TaskListSuccess(result));
    } catch (e) {
      emit(TaskListError(e.toString()));
    }
  }
}