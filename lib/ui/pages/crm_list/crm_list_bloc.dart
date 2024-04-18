import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:flutter_crm_prove/data/odoo_config.dart';
import 'package:flutter_crm_prove/domain/lead.dart';

import '../../../data/repository/repository.dart';
import 'crm_list_events.dart';
import 'crm_list_states.dart';
/// [CrmListBloc] is a bloc class, works with [CrmListEvents] and [CrmListStates],
/// wait for [CrmListEvents] and emit [CrmListStates].
class CrmListBloc extends Bloc<CrmListEvents, CrmListStates> {
  CrmListBloc() : super(CrmListInitial()) {
    odooClient.setSettings(OdooConfig.getBaseUrl(), OdooConfig.getSessionId());
    on<ChangeFilter>(listCrm);
    on<LeadSelected>(selectLead);
    on<LoadAllLeads>(loadLeads);
    on<ReloadLeads>(reloadLeads);
    on<NewLeadButtonPressed>(newLead);
  }

  OdooClient odooClient = OdooClient();
  late Repository repository = Repository(odooClient: odooClient);
  List<Lead> leads = [];

  // void getLeads() async {
  //   final response = await repository.listLeads('crm.lead', []);
  //   leads = response;
  // }

  /// [listCrm] is a function that loads the leads, depending on the filter,
  /// when [ChangeFilter] is emitted, then this function is called
  listCrm(ChangeFilter event, Emitter<CrmListStates> emit) async {
    try {
      emit(CrmListLoading());
      String? filter = event.filter;
      int idStage = 0;
      idStage = await repository.getIdByName('crm.stage', event.filter);
      filter = 'stage_id = ${event.filter}';

      List<Lead> filteredLeads = leads.where((lead) => lead.stageId == idStage).toList();
      Map<String, dynamic> data = {'leads': filteredLeads};

      emit(CrmListSort(filter, data));
    } catch (e) {
      emit(CrmListError('Hubo un error al cargar las oportunidades'));
    }
  }

  /// [selectLead] is a function that loads the lead details when [LeadSelected] is emitted
  /// then this function is called
  selectLead(LeadSelected event, Emitter<CrmListStates> emit) async {
    try {
      emit(CrmListLoading());

      final response = await repository.listLead('crm.lead', event.lead.id);

      Map<String, dynamic> data = {
        'lead': response
      };
      emit(CrmListDetail(data['lead']));
    } catch (e) {
      emit(CrmListError('Hubo un error al cargar las oportunidades'));
    }
  }

  /// [loadLeads] is a function that loads the leads when [LoadAllLeads] is emitted
  /// then this function is called
  loadLeads(LoadAllLeads event, Emitter<CrmListStates> emit) async {
    try {
      emit(CrmListLoading());
      final response = await repository.listLeads('crm.lead', []);
      leads = response;
      Map<String, dynamic> data = {
        'leads': response
      };
      emit(CrmListSuccess(data));
    } catch (e) {
      emit(CrmListError('Hubo un error al cargar las oportunidades'));
    }

  }

  /// [reloadLeads] is a function that reloads the leads when [ReloadLeads] is emitted
  /// then this function is called
  reloadLeads(ReloadLeads event, Emitter<CrmListStates> emit) async {
    try {
      emit(CrmListLoading());

      final response = await repository.listLeads('crm.lead', []);
      leads = response;

      Map<String, dynamic> data = {
        'leads': leads
      };

      emit(CrmListSuccess(data));
    } catch (e) {
      emit(CrmListError('Hubo un error al cargar las oportunidades'));
    }
  }

  /// [newLead] is a function that loads the new lead when [NewLeadButtonPressed] is emitted
  /// then this function is called
  newLead(NewLeadButtonPressed event, Emitter<CrmListStates> emit) async {
    try {
      emit(CrmListLoading());
      emit(CrmNewLead());
    } catch (e) {
      emit(CrmListError('Hubo un error al cargar las oportunidades'));
    }
  }

  /// [fetchLeadStatuses] is a function that fetches the lead statuses when [LoadAllLeads] is emitted
  /// then this function is called
  Future<List<String>> fetchLeadStatuses() async {
    try {
      List<String> leadStatuses = (await repository.getAll('crm.stage')).cast<String>();
      return leadStatuses;
    } catch (e) {
      throw Exception('Failed to fetch lead statuses: $e');
    }
  }

}
