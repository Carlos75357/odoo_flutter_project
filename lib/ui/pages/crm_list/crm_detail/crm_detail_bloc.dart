import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/data/repository/repository.dart';

import '../../../../data/json/odoo_client.dart';
import '../../../../data/odoo_config.dart';
import '../../../../domain/lead.dart';
import '../../../../domain/lead_formated.dart';
import 'crm_detail_events.dart';
import 'crm_detail_states.dart';

class CrmDetailBloc extends Bloc<CrmDetailEvents, CrmDetailStates> {
  CrmDetailBloc() : super(CrmDetailInitial()) {
    odooClient.setSettings(OdooConfig.getBaseUrl(), OdooConfig.getSessionId());
    on<LoadLead>(loadDetails);
    on<SaveLeadButtonPressed>(updateLead);
    on<ToggleEditButtonPressed>(toggleEditLead);
    on<ReloadDetail>(reloadDetails);
    on<SetState>(setState);
  }

  OdooClient odooClient = OdooClient();
  late Repository repository = Repository(odooClient: odooClient);
  Lead lead = Lead(id: 0, name: '');
  bool isEditing = false;

  setState(SetState event, Emitter<CrmDetailStates> emit) {
    try {
      emit(CrmDetailLoading());
    } catch (e) {
      emit(CrmDetailError(e.toString()));
    }
  }

  loadDetails(LoadLead event, Emitter<CrmDetailStates> emit) async {
    try {
      emit(CrmDetailLoading());

      lead = event.lead;

      emit(CrmDetailSuccess(lead));
    } catch (e) {
      emit(CrmDetailError(e.toString()));
    }
  }

  reloadDetails(ReloadDetail event, Emitter<CrmDetailStates> emit) async {
    try {
      emit(CrmDetailLoading());

      lead = await repository.listLead('crm.lead', event.id);

      emit(CrmDetailReload(lead));
    } catch (e) {
      emit(CrmDetailError(e.toString()));
    }
  }

  updateLead(SaveLeadButtonPressed event, Emitter<CrmDetailStates> emit) async {
    try {
      emit(CrmDetailLoading());

      LeadFormated leadFormated = LeadFormated.fromJson(event.changes);

      dynamic ids = await Future.wait([
        _getIdByNameOrNull('res.partner', leadFormated.client),
        _getIdByNameOrNull('res.company', leadFormated.company),
        _getIdByNameOrNull('res.users', leadFormated.user),
        _getIdByNameOrNull('crm.stage', leadFormated.stage),
        _getIdByNameOrNull('crm.team', leadFormated.team),
        _getIdsByNames('crm.tag', leadFormated.tags),
      ]);

      leadFormated.clientId = ids[0];
      leadFormated.companyId = ids[1];
      leadFormated.userId = ids[2];
      leadFormated.stageId = ids[3];
      leadFormated.teamId = ids[4];
      leadFormated.tagsId = ids[5];

      Lead leadUpdated = leadFormated.leadFormatedToLead(leadFormated);

      var response = await repository.updateLead('crm.lead', event.changes['id'], leadUpdated);

      if (response.success) {
        var responseLead = await repository.listLead('crm.lead', leadUpdated.id);

        emit(CrmDetailReload(responseLead));
      }
    } catch (e) {
      emit(CrmDetailError(e.toString()));
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


  toggleEditLead(ToggleEditButtonPressed event, Emitter<CrmDetailStates> emit) async {
    try {
      emit(CrmDetailLoading());

      isEditing = !isEditing;

      emit(CrmDetailEditing(isEditing));
    } catch (e) {
      emit(CrmDetailError(e.toString()));
    }
  }

  Future<Map<String, List<String>>> getList() async {
    try {
      Map<String, List<String>> dataList = {};

      dataList['etapas'] = (await repository.getAllNames('crm.stage')).cast<String>();
      dataList['usuarios'] = (await repository.getAllNames('res.users')).cast<String>();
      dataList['compañías'] = (await repository.getAllNames('res.company')).cast<String>();
      dataList['clientes'] = (await repository.getAllNames('crm.lead')).cast<String>();
      dataList['tags'] = (await repository.getAllNames('crm.tag')).cast<String>();

      return dataList;
    } catch (e) {
      throw Exception('Failed to get list: $e');
    }
  }

  Future<String> getDataString(int value, String modelName) async {
    try {
      switch (modelName) {
        case 'res.company':
          return repository.getNameById('res.company', value);
        case 'crm.stage':
          return repository.getNameById('crm.stage', value);
        case 'res.users':
          return repository.getNameById('res.users', value);
        case 'crm.team':
          return repository.getNameById('crm.team', value);
        case 'res.partner':
          return repository.getNameById('res.partner', value);
        default:
          throw Exception('Invalid model name: $modelName');
      }
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }

  Future<List<String>> getDataList(List<int> value, String modelName) async {
   try {
     List<String> data = [];
     switch (modelName) {
       case 'crm.tag':
         await repository.getNamesByIds('crm.tag', value).then((tags) => data.addAll(tags));
         return data;
       default:
         throw Exception('Invalid model name: $modelName');
     }
   } catch (e) {
     throw Exception('Failed to get data: $e');
   }
  }

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

  Future<List<String>> getNames(String modelName) async {
    try {
      List<String> records = await repository.getAll(modelName);
      return records;
    } catch (e) {
      throw Exception('Failed to get names: $e');
    }
  }

  Future<int> getIdByName(String modelName, String name) async {
    try {
      final response = await repository.getIdByName(modelName, name);
      return response;
    } catch (e) {
      return 0;
    }
  }

  Future<Map<String, List<String>>> getSelectedItems(Map<String, List<int>> allIds) async {
    try {
      List<String> tagNames = await repository.getNamesByIds('crm.tag', allIds['tags']);
      List<String> stageNames = await repository.getNamesByIds('crm.stage', allIds['stage']);
      List<String> userNames = await repository.getNamesByIds('res.users', allIds['user']);
      List<String> companyNames = await repository.getNamesByIds('res.company', allIds['company']);
      List<String> clientNames = await repository.getNamesByIds('res.partner', allIds['client']);

      Map<String, List<String>> items = {
        'stage': stageNames,
        'user': userNames,
        'company': companyNames,
        'client': clientNames,
        'tags': tagNames
      };

      return items;
    } catch (e) {
      return {};
    }
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
      throw Exception('Failed to translate stage: $e');
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
