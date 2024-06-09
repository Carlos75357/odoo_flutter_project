import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_events.dart';

import '../../../domain/Task/task_formated.dart';
import '../../../ui/pages/project_list/pjt_list_bloc.dart';
import '../../../ui/pages/project_list/project_detail/pjt_detail_bloc.dart';

class TaskWidget extends StatelessWidget {
  final TaskFormated task;

  const TaskWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<ProjectDetailBloc>(context).add(TaskSelected(task: task.taskFormatedToTask(task)));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 5.0),
        child: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              task.name ?? 'Sin nombre',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Asignados: ${task.assignedNames?.join(', ') ?? 'Sin asignar'}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Fecha límite: ${task.dateEnd ?? 'Sin fecha'}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'ID de etapa: ${task.stageName?.toString() ?? 'Sin etapa'}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Prioridad: ${task.priority?.toString() ?? 'Sin prioridad'}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Horas planificadas: ${task.plannedHours?.toString() ?? 'Sin horas planificadas'}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
            trailing: const Icon(Icons.edit, color: Colors.white, size: 16),
          ),
        ),
      ),
    );
  }
}
