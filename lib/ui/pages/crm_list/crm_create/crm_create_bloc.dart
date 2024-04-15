import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/data/odoo_config.dart';
import 'package:flutter_crm_prove/data/repository/repository.dart';
import 'package:flutter_crm_prove/domain/lead.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_create/crm_create_states.dart';

import 'crm_create_events.dart';

class CrmCreateBloc extends Bloc<CrmCreateEvents, CrmCreateStates> {
  CrmCreateBloc() : super(CrmCreateInitial()) {
    odooClient.setSettings(OdooConfig.getBaseUrl(), OdooConfig.getSessionId());
    on<LoadEvents>((event, emit) => loadData(event, emit));
    on<CreateEvents>((event, emit) => createlead(event, emit));
    on<SetSuccessState>((event, emit) => setSuccessState(event, emit));
    on<SetLoadingState>((event, emit) => setLoadingState(event, emit));
  }
  OdooClient odooClient = OdooClient();
  late Repository repository = Repository(odooClient: odooClient);
  List<Lead> leads = [];

  setLoadingState(SetLoadingState event, Emitter<CrmCreateStates> emit) {
    try {
      emit(CrmCreateLoading());
    } catch (e) {
      emit(CrmCreateError(e.toString()));
    }
  }

  setSuccessState(SetSuccessState event, Emitter<CrmCreateStates> emit) {
    try {
      emit(CrmCreateSuccess());
    } catch (e) {
      emit(CrmCreateError(e.toString()));
    }
  }

  loadData(LoadEvents event, Emitter<CrmCreateStates> emit) async {
    try {
      emit(CrmCreateLoading());

      List<String> leads = await repository.getAll(event.model);

      emit(CrmCreateSuccess());
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  createlead(CreateEvents event, Emitter<CrmCreateStates> emit) async {
    Map<String, dynamic> data = event.values;


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
      return await repository.getIdByName(modelName, name);
    } catch (e) {
      throw Exception('Failed to get id by name: $e');
    }
  }

  Future<List<int>> getIdsByNames(String modelName, List<String> names) async {
    try {
      return await repository.getIdsByNames(modelName, names);
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