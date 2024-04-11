import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_crm_prove/data/odoo_config.dart';
import 'package:flutter_crm_prove/data/repository/repository.dart';
import 'package:flutter_crm_prove/domain/lead.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_create/crm_create_states.dart';

import 'crm_create_events.dart';

class CrmCreateBLoc extends Bloc<CrmCreateEvents, CrmCreateStates> {
  CrmCreateBLoc() : super(CrmCreateInitial()) {
    odooClient.setSettings(OdooConfig.getBaseUrl(), OdooConfig.getSessionId());
  }
  OdooClient odooClient = OdooClient();
  late Repository repository = Repository(odooClient: odooClient);
  List<Lead> leads = [];

}