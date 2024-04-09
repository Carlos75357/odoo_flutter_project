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
  }

  OdooClient odooClient = OdooClient();
  late Repository repository = Repository(odooClient: odooClient);
  Lead lead = Lead(id: 0, name: '');
  bool isEditing = false;

  loadDetails(LoadLead event, Emitter<CrmDetailStates> emit) async {
    try {
      emit(CrmDetailLoading());

      lead = event.lead;

      emit(CrmDetailSuccess(lead));
    } catch (e) {
      emit(CrmDetailError(e.toString()));
    }
  }

  updateLead(SaveLeadButtonPressed event, Emitter<CrmDetailStates> emit) async {
    try {
      emit(CrmDetailLoading());

      LeadFormated leadFormated = LeadFormated.fromJson(event.changes);

      if (leadFormated.client != null) {
        leadFormated.clientId = await repository.getIdByName('res.partner', leadFormated.client!);
      } else if (leadFormated.client == 'Ninguno') {
        leadFormated.clientId = null;
      }

      if (leadFormated.company != null) {
        leadFormated.companyId = await repository.getIdByName('res.company', leadFormated.company!);
      } else if (leadFormated.company == 'Ninguno') {
        leadFormated.companyId = null;
      }

      if (leadFormated.user != null) {
        leadFormated.userId = await repository.getIdByName('res.users', leadFormated.user!);
      } else if (leadFormated.user == 'Ninguno') {
        leadFormated.userId = null;
      }

      if (leadFormated.stage != null) {
        leadFormated.stageId = await repository.getIdByName('crm.stage', leadFormated.stage!);
      }

      if (leadFormated.tags != null) {
        for (var tag in leadFormated.tags!) {
          leadFormated.tagsId?.add(await repository.getIdByName('crm.tag', tag));
        }
      } else if (leadFormated.tags == ['Ninguno']) {
        leadFormated.tagsId = null;
      }

      Lead leadUpdated = leadFormated.leadFormatedToLead(leadFormated);

      var response = await repository.updateLead('crm.lead', event.changes['id'], leadUpdated);

      if (response.success) {
        var responseList = await repository.listLead('crm.lead', leadUpdated.id);

        emit(CrmDetailSuccess(responseList));
      }
    } catch (e) {
      emit(CrmDetailError(e.toString()));
    }
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

      Map<String, List<String>> fieldsOptions = {
        'stage': stageNames,
        'user': userNames,
        'company': companyNames,
        'client': clientNames,
        'tags': tagNames
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
        tags: translatedTags,
        tagsId: lead.tagIds,
        dateDeadline: lead.dateDeadline,
        expectedRevenue: lead.expectedRevenue,
        probability: lead.probability,
      );

      return leadFormated;
    } catch (e) {
      throw Exception('Failed to get lead formated: $e');
    }
  }

  Future<String?> translateStage(int? stageId) async {
    if (stageId == null) return null;

    switch (stageId) {
      case 1:
        return 'Nuevo';
      case 2:
        return 'Calificado';
      case 3:
        return 'Propuesta';
      case 4:
        return 'Ganado';
      default:
        return null;
    }
  }

  Future<List<String>> translateTags(List<int>? tagIds) async {
    if (tagIds == null || tagIds.isEmpty) return [];

    List<String> translatedTags = [];
    for (int tagId in tagIds) {
      String? translatedTag = await translateTag(tagId);
      if (translatedTag != null) {
        translatedTags.add(translatedTag);
      }
    }
    return translatedTags;
  }

  Future<String?> translateTag(int tagId) async {
    switch (tagId) {
      case 1:
        return 'Producto';
      case 2:
        return 'Software';
      case 3:
        return 'Servicios';
      case 4:
        return 'Información';
      case 5:
        return 'Diseño';
      case 6:
        return 'Formación';
      case 7:
        return 'Consultoría';
      case 8:
        return 'Otro';
      default:
        return null;
    }
  }
}
