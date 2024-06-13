import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/pjt_list_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/pjt_list_events.dart';

import '../../domain/project/project.dart';
import '../../domain/project/project_formated.dart';

class ProjectWidget extends StatelessWidget {
  final ProjectFormated projectFormated;

  const ProjectWidget({Key? key, required this.projectFormated}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Project project = projectFormated.projectFormatedToProject(projectFormated);
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
              projectFormated.name ?? 'Sin nombre',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Responsable: ${projectFormated.userId ?? 'Sin responsable'}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                //Text(
                  //'Fecha de creación: ${projectFormated.dateStart != null ? projectFormated.dateStart! : 'Sin fecha'}',
                  //style: const TextStyle(color: Colors.white, fontSize: 12),
                //),
                Text(
                  'Fecha límite: ${projectFormated.date != null ? projectFormated.date! : 'Sin fecha'}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Cantidad de tareas: ${projectFormated.tasks?.length ?? 0}', // Assuming `tagIds` represents tasks
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  'Estado: ${projectFormated.status ?? 'Sin estado'}',
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