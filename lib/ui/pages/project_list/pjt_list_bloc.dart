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
      List<ProjectFormated> projectsFormated = [];
      final response = await repository.listProjects("project.project", [], {});
      projects = response;
      Map<String, dynamic> data = {
        'projects': response
      };

      // obtener project formated

      for (var project in projects) {

        ProjectFormated projectFormated = ProjectFormated(
          id: project.id,
          name: project.name,
          taskName: project.taskName,
          partnerId: project.partnerId,
          partnerName: await repository.getNameById('res.partner', project.partnerId ?? 0),
          typeIds: project.typeIds,
          companyId: project.companyId,
          companyName: await repository.getNameById('res.company', project.companyId ?? 0),
          userId: project.userId,
          userName: await repository.getNameById('res.users', project.userId ?? 0),
          tagIds: project.tagIds,
          tagNames: await repository.getNamesByIds('project.tags', project.tagIds ?? []),
          status: project.status,
          stageId: project.stageId,
          stageName: await repository.getNameById('project.task.type', project.stageId ?? 0),
          dateStart: project.dateStart,
          date: project.date,
          tasks: project.tasks
        );

        projectsFormated.add(projectFormated);
      }


      data = {
        'projects_formated': response,
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