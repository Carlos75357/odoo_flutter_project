import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:flutter_crm_prove/data/odoo_config.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_detail/crm_detail.dart';

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
  }

  OdooClient odooClient = OdooClient();
  late Repository repository = Repository(odooClient: odooClient);

  listCrm(ChangeFilter event, Emitter<CrmListStates> emit) async {
    try {
      CrmListLoading();
      String? filter = event.filter;
      if (event.filter == 'Ver todos') {
        filter = null;
      } else {
        filter = 'stage_id = ${event.filter}';
      }
      final response = await repository.listLeads('crm.lead', [filter as List]);

      if (response.isEmpty) {
        emit(CrmListEmpty());
      }

      emit(CrmListSort(filter!, response as Map<String, dynamic>));
    } catch (e) {
      emit(CrmListError('Hubo un error al cargar las oportunidades'));
    }
  }

  selectLead(LeadSelected event, Emitter<CrmListStates> emit) async {
    try {
      CrmListLoading();

      final response = await repository.listLead('crm.lead', event.leadId);

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
      CrmListLoading();
      final response = await repository.listLeads('crm.lead', []);
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
      CrmListLoading();

      final response = repository.listLeads('crm.lead', []);

      emit(CrmListSuccess(response as Map<String, dynamic>));
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

  Stream<CrmListStates> mapEventToState(CrmListEvents event, Emitter<CrmListStates> emit) async* {
    if (event is LoadAllLeads) {
      CrmListLoading();

      final response = await repository.listLeads('crm.lead', []);

      if (response.isEmpty) {
        emit(CrmListEmpty());
      }

      emit(CrmListSuccess(response as Map<String, dynamic>));
    } else if (event is LoadLeads) {
      CrmListLoading();

      final response = await repository.listLeads('crm.lead', []);
    }
  }
}