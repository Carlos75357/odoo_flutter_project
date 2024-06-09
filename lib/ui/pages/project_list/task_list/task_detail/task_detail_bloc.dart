import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_crm_prove/domain/Task/task_formated.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_detail/task_detail_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_detail/task_detail_states.dart';

import '../../../../../data/json/odoo_client.dart';
import '../../../../../data/odoo_config.dart';
import '../../../../../data/repository/task/task_repository.dart';
import '../../../../../domain/Task/task.dart';

class TaskDetailBloc extends Bloc<TaskDetailEvents, TaskDetailStates> {
   TaskDetailBloc() : super(TaskDetailInitial()) {
      odooClient.setSettings(OdooConfig.getBaseUrl(), OdooConfig.getSessionId());
      on<SetState>(setState);
      on<TaskDetailSuccess>(setSuccessState);
   }

   setState(SetState event, Emitter<TaskDetailStates> emit) {
      try {
         emit(TaskDetailLoading());
      } catch (e) {
         emit(TaskDetailErrorState(e.toString()));
         FirebaseCrashlytics.instance.recordError(e, null, fatal: true);
      }
   }

   setSuccessState(TaskDetailSuccess state, Emitter<TaskDetailStates> emit) {
      try {
         emit(TaskDetailSuccessState());
      } catch (e) {
         emit(TaskDetailErrorState(e.toString()));
         FirebaseCrashlytics.instance.recordError(e, null, fatal: true);
      }
   }

   OdooClient odooClient = OdooClient();
   late TaskRepository repository = TaskRepository(odooClient: odooClient);
   List<Task> tasks = [];

   Future<TaskFormated> getTaskFormated(Task task) async {
      try {

         List<Future> futures = [
            repository.getNamesByIds('res.partner', task.assignedIds),
            repository.getNameById('res.partner', task.clientId ?? 0),
            repository.getNamesByIds('project.tags', task.tagIds),
            repository.getNameById('res.company', task.companyId ?? 0),
            repository.getNameById('project.task.type', task.stageId ?? 0),
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

         return taskFormated;
      } catch (e) {
         throw Exception('Failed to get task formatted: $e');
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
}