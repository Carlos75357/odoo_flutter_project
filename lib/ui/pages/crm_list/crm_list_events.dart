
import '../../../domain/crm/lead.dart';

/// [CrmListEvents] is an abstract class that defines events related to the [CrmListPage].
abstract class CrmListEvents {}

/// [LoadLeads] event when the page is loading.
class LoadLeads extends CrmListEvents {}

/// [ChangeFilter] event when the filter is changed.
class ChangeFilterCrm extends CrmListEvents {
  final String filter;

  ChangeFilterCrm({required this.filter});
}
/// [LeadSelected] event when a lead is selected.
class LeadSelected extends CrmListEvents {
  final Lead lead;

  LeadSelected({required this.lead});
}
/// [LoadAllLeads] event when the page is loading.
class LoadAllLeads extends CrmListEvents {}

/// [ReloadLeads] event when the page is reloading.
class ReloadLeads extends CrmListEvents {}

/// [NewLeadButtonPressed] event when the new lead button is pressed.
class NewLeadButtonPressed extends CrmListEvents {}