import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/pjt_list_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/pjt_list_events.dart';

import '../../domain/project/project.dart';

class ProjectWidget extends StatelessWidget {
  final Project project;

  const ProjectWidget({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<PjtListBloc>(context).add(PjtSelected(project: project));
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
              project.name ?? 'Sin nombre',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Responsable: ${project.userId ?? 'Sin responsable'}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Fecha de creación: ${project.dateStart != null ? project.dateStart! : 'Sin fecha'}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Fecha límite: ${project.date != null ? project.date! : 'Sin fecha'}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Cantidad de tareas: ${project.tasks?.length ?? 0}', // Assuming `tagIds` represents tasks
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Estado: ${project.status ?? 'Sin estado'}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                // Text(
                //   'Etapa: ${project.stageId ?? 'Sin etapa'}',
                //   style: const TextStyle(color: Colors.white, fontSize: 12),
                // ),
              ],
            ),
            trailing: const Icon(Icons.edit, color: Colors.white, size: 16),
          ),
        ),
      ),
    );
  }
}