import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/domain/project/project_formated.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/project_edit/pjt_edit_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/project_edit/pjt_edit_states.dart';

import '../../../../../data/json/odoo_client.dart';
import '../../../../../data/odoo_config.dart';
import '../../../../../data/repository/project/pjt_repository.dart';
import '../../../../../domain/project/project.dart';

class ProjectEditBloc extends Bloc<ProjectEditEvent, ProjectEditStates> {
  ProjectEditBloc() : super(ProjectEditInitial()) {
    odooClient.setSettings(OdooConfig.getBaseUrl(), OdooConfig.getSessionId());
    on<SetState>(setState);
    // on<UpdateProject>(updateProject);
    on<StateSuccess>(setStateSucces);
  }

  OdooClient odooClient = OdooClient();
  late RepositoryProject projectRepository = RepositoryProject(odooClient: odooClient);
  Project project = Project(id: 0);

  setState(SetState state, Emitter emit) {
    try {
      emit(ProjectEditLoading());
      project = state.project;
    } catch (e) {
      emit(ProjectEditError('Error'));
    }
  }

  setStateSucces(StateSuccess state, Emitter emit) {
    try {
      emit(ProjectEditSuccess());
    } catch (e) {
      emit(ProjectEditError('Error'));
    }
  }

  updateProject(UpdatePjt state, Emitter emit) async {
    try {
      emit(ProjectEditLoading());

      ProjectFormated projectFormated = state.projectF;

      dynamic ids = await Future.wait([
        _getIdByNameOrNull('res.partner', projectFormated.partnerName),
        _getIdByNameOrNull('res.company', projectFormated.companyName),
        _getIdByNameOrNull('res.users', projectFormated.userName),
        _getIdByNameOrNull('project.project.stage', projectFormated.stageName),
        _getIdsByNames('project.project.tag', projectFormated.tagNames),
      ]);

      projectFormated.partnerId = ids[0];
      projectFormated.companyId = ids[1];
      projectFormated.userId = ids[2];
      projectFormated.stageId = ids[3];
      projectFormated.tagIds = ids[4];

      Project projectFromFormated = projectFormated.projectFormatedToProject(projectFormated);

      var response = await projectRepository.updateProject('project.project', project.id, projectFromFormated);

      if (response.success) {
        emit(ProjectEditUpdate(projectFromFormated));
      }

      // emit(ProjectEditUpdate(state.data));
    } catch (e) {
      emit(ProjectEditError('Error'));
    }
  }

  Future<ProjectFormated> getProjectFormated(Project project) async {
    try {
      String? stageName = await translateStage(project.stageId);

      List<String>? tagNames = await translateTags(project.tagIds);

      return ProjectFormated(
        id: project.id,
        name: project.name,
        taskName: project.taskName,
        partnerId: project.partnerId,
        partnerName: await projectRepository.getNameById('res.partner', project.partnerId ?? 0),
        companyId: project.companyId,
        companyName: await projectRepository.getNameById('res.company', project.companyId ?? 0),
        userId: project.userId,
        userName: await projectRepository.getNameById('res.users', project.userId ?? 0),
        tagIds: project.tagIds,
        tagNames: tagNames,
        status: project.status,
        stageId: project.stageId,
        stageName: stageName,
        dateStart: project.dateStart,
        date: project.date,
        tasks: project.tasks
      );

    } catch (e) {
      throw Exception('Failed to get project formated: $e');
    }
  }

  Future<int> getIdByName(String modelName, String name) async {
    try {
      return await projectRepository.getIdByName(modelName, name);
    } catch (e) {
      throw Exception('Failed to get id by name: $e');
    }
  }

  Future<String?> translateStage(int? stageId) async {
    if (stageId == null) return null;

    try {

      String? stageName = await projectRepository.getNameById('project.project.stage', stageId);

      if (stageName != null) {
        return stageName;
      }

      return null;
    } catch (e) {
      throw Exception('Failed to translate stage: $e');
    }
  }

  Future<List<String>> translateTags(List<int>? tagIds) async {
    if (tagIds == null || tagIds.isEmpty) return [];

    try {
      List<String> translatedTags = [];

      List<String> tags = await projectRepository.getNamesByIds('mail.activity.type', tagIds);

      translatedTags.addAll(tags);

      return translatedTags;
    } catch (e) {
      throw Exception('Failed to translate tags: $e');
    }
  }

  Future<int?> _getIdByNameOrNull(String objectType, String? name) async {
    if (name == null) return null;
    if (name == 'Ninguno') return null;
    return projectRepository.getIdByName(objectType, name);
  }

  Future<List<int>> _getIdsByNames(String objectType, List<String>? names) async {
    if (names == null) return [];
    if (names.contains('Ninguno')) return [];
    var ids = await Future.wait(names.map((name) => projectRepository.getIdByName(objectType, name)));
    return ids;
  }
}