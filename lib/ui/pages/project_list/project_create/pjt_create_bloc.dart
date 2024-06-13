import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/data/odoo_config.dart';
import 'package:flutter_crm_prove/data/repository/project/pjt_repository.dart';
import 'package:flutter_crm_prove/domain/project/project_formated.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_create/crm_create_states.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_create/pjt_create_states.dart';

import '../../../../data/repository/crm/crm_repository.dart';
import '../../../../data/repository/crm/crm_repository_response.dart';
import '../../../../domain/crm/lead.dart';
import '../../../../domain/crm/lead_formated.dart';
import '../../../../domain/project/project.dart';
import 'pjt_create_events.dart';

class ProjectCreateBloc extends Bloc<ProjectCreateEvents, ProjectCreateStates> {
  ProjectCreateBloc() : super(ProjectCreateInitial()) {
    odooClient.setSettings(OdooConfig.getBaseUrl(), OdooConfig.getSessionId());
    on<CreateEvents>(createLead);
    on<SetSuccessState>(setSuccessState);
    on<SetLoadingState>(setLoadingState);
  }
  OdooClient odooClient = OdooClient();
  late RepositoryProject repository = RepositoryProject(odooClient: odooClient);
  List<Lead> leads = [];

  setLoadingState(SetLoadingState event, Emitter<ProjectCreateStates> emit) {
    try {
      emit(ProjectCreateLoading());
    } catch (e) {
      emit(ProjectCreateError(e.toString()));
    }
  }

  setSuccessState(SetSuccessState event, Emitter<ProjectCreateStates> emit) {
    try {
      emit(ProjectCreateSuccess());
    } catch (e) {
      emit(ProjectCreateError(e.toString()));
    }
  }

  createLead(CreateEvents event, Emitter<ProjectCreateStates> emit) async {
    emit(ProjectCreateLoading());
    Map<String, dynamic> data = event.values;

    dynamic ids = await Future.wait([
      _getIdsByNames('project.task.type', data['stages']),
    ]);

    if (data.containsKey('stages')) {
      data['stages_id'] = ids[0];
      data.remove('stages');
    }

    ProjectFormated projectFormated = ProjectFormated.fromJson(data);

    Project project = projectFormated.projectFormatedToProject(projectFormated);

    CreateResponse responseC = await repository.createProject('project.project', project.toJson());
    Map<String, dynamic> values = {
      'tasks_stage_id': project.tasksStageId,
    };
    WriteResponse responseW = await repository.updateStage('project.project', project.id, values);

    if (responseC.success && responseW.success) {
      emit(ProjectCreateDone());
    } else {
      emit(ProjectCreateError('Failed to create lead'));
    }
  }

  Future<int?> _getIdByNameOrNull(String objectType, String? name) async {
    if (name == null) return null;
    if (name == 'Ninguno') return null;
    return repository.getIdByName(objectType, name);
  }

  Future<List<int>> _getIdsByNames(String objectType, List<String>? names) async {
    if (names == null) return [];
    if (names.contains('Ninguno')) return [];
    var ids = await Future.wait(names.map((name) => repository.getIdByName(objectType, name)));
    return ids;
  }

  Future<LeadFormated> getLeadFormated(Lead lead) async {
    try {
      String? stageName = await translateStage(lead.stageId);
      List<String>? translatedTags = await translateTags(lead.tagIds);

      LeadFormated leadFormated = LeadFormated(
        id: lead.id,
        name: lead.name ?? '',
        email: lead.email,
        phone: lead.phone,
        clientId: lead.clientId,
        client: await repository.getNameById('res.partner', lead.clientId ?? 0),
        company: await repository.getNameById('res.company', lead.companyId ?? 0),
        companyId: lead.companyId,
        stage: stageName,
        stageId: lead.stageId,
        user: await repository.getNameById('res.users', lead.userId ?? 0),
        userId: lead.userId,
        team: await translateTeam(lead.teamId),
        teamId: lead.teamId,
        tags: translatedTags,
        tagsId: lead.tagIds,
        dateDeadline: lead.dateDeadline,
        expectedRevenue: lead.expectedRevenue,
        probability: double.tryParse('${lead.probability}'),
      );

      return leadFormated;
    } catch (e) {
      throw Exception('Failed to get lead formated: $e');
    }
  }

  Future<Map<String, List<String>>> getFieldsOptions() async {
    try {
      List<String> stagesNames = await getNames('project.task.type');

      Map<String, List<String>> fieldsOptions = {
        'stage': stagesNames,
      };

      return fieldsOptions;
    } catch (e) {
      throw Exception('Failed to get field options: $e');
    }
  }

  Future<List<String>> getNames(String modelName) async {
    try {
      List<String> records = await repository.getAllNames(modelName, ['name']);
      return records;
    } catch (e) {
      throw Exception('Failed to get names: $e');
    }
  }

  Future<int> getIdByName(String modelName, String name) async {
    try {
      return await repository.getIdByName(modelName, name);
    } catch (e) {
      throw Exception('Failed to get id by name: $e');
    }
  }

  Future<List<int>> getIdsByNames(String modelName, List<String> names) async {
    try {
      return await repository.getIdsByName(modelName, names);
    } catch (e) {
      throw Exception('Failed to get ids by names: $e');
    }
  }

  Future<String?> translateStage(int? stageId) async {
    if (stageId == null) return null;

    try {
      List<Map<String, dynamic>> stages = await repository.getAllForModel('crm.stage', ['id', 'name']);

      for (var stage in stages) {
        if (stage['id'] == stageId) {
          return stage['name'];
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> translateTeam(int? teamId) async {
    if (teamId == null) return null;

    try {
      List<Map<String, dynamic>> teams = await repository.getAllForModel('crm.team', ['id', 'name']);

      for (var team in teams) {
        if (team['id'] == teamId) {
          return team['name'];
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> translateTags(List<int>? tagIds) async {
    if (tagIds == null || tagIds.isEmpty) return [];

    try {
      List<String> translatedTags = [];

      List<Map<String, dynamic>> tags = await repository.getAllForModel('crm.tag', ['id', 'name']);

      for (int tagId in tagIds) {
        Map<String, dynamic>? tag = tags.firstWhere((tag) => tag['id'] == tagId, orElse: () => throw Exception('Tag with ID $tagId not found.'));
        translatedTags.add(tag['name']);
      }
      return translatedTags;
    } catch (e) {
      throw Exception('Failed to translate tags: $e');
    }
  }
}