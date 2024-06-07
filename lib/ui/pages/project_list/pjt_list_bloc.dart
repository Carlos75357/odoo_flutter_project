import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/data/repository/project/pjt_repository.dart';
import 'package:flutter_crm_prove/domain/project/project_formated.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/pjt_list_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/pjt_list_states.dart';

import '../../../data/json/odoo_client.dart';
import '../../../data/odoo_config.dart';
import '../../../domain/project/project.dart';

class PjtListBloc extends Bloc<PjtListEvents, PjtListStates> {
  PjtListBloc() : super(PjtListInitial()) {
    odooClient.setSettings(OdooConfig.getBaseUrl(), OdooConfig.getSessionId());
    on<LoadAll>(listProjects);
    on<PjtSelected>(selectProject);
    on<CreateNewPjt>(newProject);
    on<ReloadAll>(reloadProject);
  }

  OdooClient odooClient = OdooClient();
  late RepositoryProject repository = RepositoryProject(odooClient: odooClient);
  List<Project> projects = [];

  listProjects(LoadAll event, Emitter<PjtListStates> emit) async {
    try {
      emit(PjtListLoading());
      final response = await repository.listProjects("project.project", [], {});
      projects = response;
      Map<String, dynamic> data = {
        'projects': response
      };

      // obtener project formated

      List<ProjectFormated> formattedProjects = [];

      for (var project in projects) {
        List<Future> futures = [
          repository.getNameById('res.partner', project.partnerId ?? 0),
          repository.getNameById('res.company', project.companyId ?? 0),
          repository.getNameById('res.users', project.userId ?? 0),
          repository.getNamesByIds('project.tags', project.tagIds ?? []),
          repository.getNameById('project.task.type', project.stageId ?? 0),
        ];

        List results = await Future.wait(futures);

        String partnerName = results[0];
        String companyName = results[1];
        String userName = results[2];
        List<String> tagNames = results[3];
        String stageName = results[4];

        ProjectFormated projectFormated = ProjectFormated(
          id: project.id,
          name: project.name,
          taskName: project.taskName,
          partnerId: project.partnerId,
          partnerName: partnerName,
          typeIds: project.typeIds,
          companyId: project.companyId,
          companyName: companyName,
          userId: project.userId,
          userName: userName,
          tagIds: project.tagIds,
          tagNames: tagNames,
          status: project.status,
          stageId: project.stageId,
          stageName: stageName,
          dateStart: project.dateStart,
          date: project.date,
          tasks: project.tasks,
        );

        formattedProjects.add(projectFormated);
      }



      data = {
        'projects_formated': formattedProjects,
      };

      emit(PjtListSuccess(data));
    } catch (e) {
      emit(PjtListError("Ha habido un error al cargar los proyectos"));
    }
  }

  selectProject(PjtSelected event, Emitter<PjtListStates> emit) async {
    try {
      emit(PjtListLoading());

      emit(PjtDetail(event.project));
    } catch (e) {
      emit(PjtListError("Ha habido un error al cargar los proyectos"));
    }
  }

  newProject(CreateNewPjt event, Emitter<PjtListStates> emit) {
    try {
      emit(PjtListLoading());
      emit(PjtNew());
    } catch (e) {
      emit(PjtListError("Ha habido un error al cargar los proyectos"));
    }
  }

  reloadProject(ReloadAll event, Emitter<PjtListStates> emit) async {
    try {
      emit(PjtListLoading());

      final response = await repository.listProjects("project.project", [], {});
      projects = response;

      Map<String, dynamic> data = {
        'projects': response
      };

      emit(PjtListSuccess(data));
    } catch (e) {
      emit(PjtListError("Ha habido un error al cargar los proyectos"));
    }
  }
}