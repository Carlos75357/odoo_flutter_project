import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:flutter_crm_prove/data/odoo_config.dart';
import 'package:flutter_crm_prove/domain/lead.dart';

import '../../../data/repository/repository.dart';
import 'crm_list_events.dart';
import 'crm_list_states.dart';

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

  listCrm(ChangeFilter event, Emitter<CrmListStates> emit) async {
    try {
      emit(CrmListLoading());
      String? filter = event.filter;
      int idStage = 0;
      idStage = await repository.stageIdByName(event.filter);
      filter = 'stage_id = ${event.filter}';

      List<Lead> filteredLeads = leads.where((lead) => lead.stageId == idStage).toList();
      Map<String, dynamic> data = {'leads': filteredLeads};

      emit(CrmListSort(filter, data));
    } catch (e) {
      emit(CrmListError('Hubo un error al cargar las oportunidades'));
    }
  }

  selectLead(LeadSelected event, Emitter<CrmListStates> emit) async {
    try {
      emit(CrmListLoading());

      final response = await repository.listLead('crm.lead', event.lead.id);

      Map<String, dynamic> data = {
        'lead': response
      };
      emit(CrmListDetail(data['lead'].id));
    } catch (e) {
      emit(CrmListError('Hubo un error al cargar las oportunidades'));
    }
  }

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

  reloadLeads(ReloadLeads event, Emitter<CrmListStates> emit) {
    try {
      emit(CrmListLoading());

      Map<String, dynamic> data = {
        'leads': leads
      };

      emit(CrmListSuccess(data));
    } catch (e) {
      emit(CrmListError('Hubo un error al cargar las oportunidades'));
    }
  }

  newLead(NewLeadButtonPressed event, Emitter<CrmListStates> emit) async {
    try {
      emit(CrmListLoading());
      emit(CrmNewLead());
    } catch (e) {
      emit(CrmListError('Hubo un error al cargar las oportunidades'));
    }
  }

  Future<List<String>> fetchLeadStatuses() async {
    try {
      List<String> leadStatuses = await repository.stageNames();
      return leadStatuses;
    } catch (e) {
      throw Exception('Failed to fetch lead statuses: $e');
    }
  }

  // Stream<CrmListStates> mapEventToState(CrmListEvents event, Emitter<CrmListStates> emit) async* {
  //   if (event is LoadAllLeads) {
  //     CrmListLoading();
  //
  //     final response = await repository.listLeads('crm.lead', []);
  //
  //     if (response.isEmpty) {
  //       emit(CrmListEmpty());
  //     }
  //
  //     emit(CrmListSuccess(response as Map<String, dynamic>));
  //   } else if (event is LoadLeads) {
  //     CrmListLoading();
  //
  //     final response = await repository.listLeads('crm.lead', []);
  //   }
  // }
}
