import 'package:flutter_crm_prove/domain/lead.dart';

abstract class CrmListEvents {}

class LoadLeads extends CrmListEvents {}

class ChangeFilter extends CrmListEvents {
  final String filter;

  ChangeFilter({required this.filter});
}

class LeadSelected extends CrmListEvents {
  final Lead lead;

  LeadSelected({required this.lead});
}

class LoadAllLeads extends CrmListEvents {}

class ReloadLeads extends CrmListEvents {}

class NewLeadButtonPressed extends CrmListEvents {}