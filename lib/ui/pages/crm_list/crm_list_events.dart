abstract class CrmListEvents {}

class LoadLeads extends CrmListEvents {}

class ChangeFilter extends CrmListEvents {
  final String filter;

  ChangeFilter({required this.filter});
}

class LeadSelected extends CrmListEvents {
  final int leadId;

  LeadSelected({required this.leadId});
}

class LoadAllLeads extends CrmListEvents {}

class ReloadLeads extends CrmListEvents {}