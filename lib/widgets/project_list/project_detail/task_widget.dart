import 'package:flutter/material.dart';

import '../../../domain/project/task.dart';

class TaskWidget extends StatelessWidget {
  final Task task;

  const TaskWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // BlocProvider.of<PjtListBloc>(context).add(PjtSelected(project: project));
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
                  'Asignados: ${task.assigned?.join(', ') ?? 'Sin asignar'}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Fecha límite: ${task.dateEnd ?? 'Sin fecha'}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'ID de etapa: ${task.stageId?.toString() ?? 'Sin etapa'}',
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
