import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/data/odoo_config.dart';
import 'package:flutter_crm_prove/data/repository/repository.dart';
import 'package:flutter_crm_prove/domain/lead.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_create/crm_create_states.dart';

import '../../../../data/repository/repository_response.dart';
import '../../../../domain/lead_formated.dart';
import 'crm_create_events.dart';

/// [CrmCreateBloc] is a bloc class, works with [CrmCreateEvents] and [CrmCreateStates],
class CrmCreateBloc extends Bloc<CrmCreateEvents, CrmCreateStates> {
  CrmCreateBloc() : super(CrmCreateInitial()) {
    odooClient.setSettings(OdooConfig.getBaseUrl(), OdooConfig.getSessionId());
    on<CreateEvents>((event, emit) => createLead(event, emit));
    on<SetSuccessState>((event, emit) => setSuccessState(event, emit));
    on<SetLoadingState>((event, emit) => setLoadingState(event, emit));
  }
  OdooClient odooClient = OdooClient();
  late Repository repository = Repository(odooClient: odooClient);
  List<Lead> leads = [];

  /// [setLoadingState] method to set the [CrmCreateStates] to [CrmCreateLoading].
  setLoadingState(SetLoadingState event, Emitter<CrmCreateStates> emit) {
    try {
      emit(CrmCreateLoading());
    } catch (e) {
      emit(CrmCreateError(e.toString()));
    }
  }

  /// [setSuccessState] method to set the [CrmCreateStates] to [CrmCreateSuccess].
  setSuccessState(SetSuccessState event, Emitter<CrmCreateStates> emit) {
    try {
      emit(CrmCreateSuccess());
    } catch (e) {
      emit(CrmCreateError(e.toString()));
    }
  }

  /// [createLead] method to create a new lead.
  createLead(CreateEvents event, Emitter<CrmCreateStates> emit) async {
    emit(CrmCreateLoading());
    Map<String, dynamic> data = event.values;

    dynamic ids = await Future.wait([
      _getIdByNameOrNull('res.partner', data['client']),
      _getIdByNameOrNull('res.company', data['company']),
      _getIdByNameOrNull('res.users', data['user']),
      _getIdByNameOrNull('crm.stage', data['stage']),
      _getIdByNameOrNull('crm.team', data['team']),
      _getIdsByNames('crm.tag', data['tags']),
    ]);

    if (data.containsKey('client')) {
      data['client_id'] = ids[0];
      data.remove('client');
    }
    if (data.containsKey('company')) {
      data['company_id'] = ids[1];
      data.remove('company');
    }
    if (data.containsKey('user')) {
      data['user_id'] = ids[2];
      data.remove('user');
    }
    if (data.containsKey('stage')) {
      data['stage_id'] = ids[3];
      data.remove('stage');
    }
    if (data.containsKey('team')) {
      data['team_id'] = ids[4];
      data.remove('team');
    }
    if (data.containsKey('tags')) {
      data['tags_id'] = ids[5];
      data.remove('tags');
    }

    LeadFormated leadFormated = LeadFormated.fromJson(data);

    Lead lead = leadFormated.leadFormatedToLead(leadFormated);

    CreateResponse response = await repository.createLead('crm.lead', lead.toJson());

    if (response.success) {
      emit(CrmCreateDone());
    } else {
      emit(CrmCreateError('Failed to create lead'));
    }
  }

  /// [getIdByName] method to get id by name.
  Future<int?> _getIdByNameOrNull(String objectType, String? name) async {
    if (name == null) return null;
    if (name == 'Ninguno') return null;
    return repository.getIdByName(objectType, name);
  }

  /// [getIdsByNames] method to get ids by names.
  Future<List<int>> _getIdsByNames(String objectType, List<String>? names) async {
    if (names == null) return [];
    if (names.contains('Ninguno')) return [];
    var ids = await Future.wait(names.map((name) => repository.getIdByName(objectType, name)));
    return ids;
  }

  /// [getLeadFormated] method to get lead formated.
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

  /// [getFieldsOptions] method to get fields options.
  Future<Map<String, List<String>>> getFieldsOptions() async {
    try {
      List<String> tagNames = await getNames('crm.tag');
      List<String> stageNames = await getNames('crm.stage');
      List<String> userNames = await getNames('res.users');
      List<String> companyNames = await getNames('res.company');
      List<String> clientNames = await getNames('res.partner');
      List<String> teamNames = await getNames('crm.team');

      Map<String, List<String>> fieldsOptions = {
        'stage': stageNames,
        'user': userNames,
        'company': companyNames,
        'client': clientNames,
        'tags': tagNames,
        'team': teamNames
      };

      return fieldsOptions;
    } catch (e) {
      throw Exception('Failed to get field options: $e');
    }
  }

  /// [getNames] method to get names.
  Future<List<String>> getNames(String modelName) async {
    try {
      List<String> records = await repository.getAll(modelName);
      return records;
    } catch (e) {
      throw Exception('Failed to get names: $e');
    }
  }

  /// [getIdByName] method to get id by name.
  Future<int> getIdByName(String modelName, String name) async {
    try {
      return await repository.getIdByName(modelName, name);
    } catch (e) {
      throw Exception('Failed to get id by name: $e');
    }
  }

  /// [getIdsByNames] method to get ids by names.
  Future<List<int>> getIdsByNames(String modelName, List<String> names) async {
    try {
      return await repository.getIdsByNames(modelName, names);
    } catch (e) {
      throw Exception('Failed to get ids by names: $e');
    }
  }

  /// [translateStage] method to translate stage.
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

  /// [translateTeam] method to translate team.
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

  /// [translateTags] method to translate tags.
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