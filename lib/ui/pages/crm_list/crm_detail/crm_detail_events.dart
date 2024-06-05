import 'package:flutter_crm_prove/ui/pages/crm_list/crm_detail/crm_detail_states.dart';

import '../../../../domain/crm/lead.dart';

/// [CrmDetailEvents] is an abstract class that defines events related to the [CrmDetailPage].
abstract class CrmDetailEvents {}

/// [CrmDetailEvents] is an implementation of [CrmDetailEvents] that represents the load state of the [CrmDetailStates], it receives a [Lead] as a parameter.
class LoadLead extends CrmDetailEvents {
  final Lead lead;

  LoadLead(this.lead);
}

/// [CrmDetailEvents] is an implementation of [CrmDetailEvents] that represents the save state of the [CrmDetailStates], it receives a [Map<String, dynamic>] as a parameter.
class SaveLeadButtonPressed extends CrmDetailEvents {
  final Map<String, dynamic> changes;

  SaveLeadButtonPressed(this.changes);
}

/// [CrmDetailEvents] is an implementation of [CrmDetailEvents] that represents the unlink state of the [CrmDetailStates], it receives a [int] what is the lead id as a parameter.
class UnlinkLeadButtonPressed extends CrmDetailEvents {
  final int id;

  UnlinkLeadButtonPressed(this.id);
}

/// [ToggleEditButtonPressed] is an event in [CrmDetailBloc] that toggles the editing state on the [CrmDetailPage].
/// This event is used to switch between view and edit mode, allowing the user to modify the details of a CRM entry.
class ToggleEditButtonPressed extends CrmDetailEvents {

}

/// [ReloadDetail] is an event in [CrmDetailBloc] that reloads the detail of a CRM entry.
class ReloadDetail extends CrmDetailEvents {
  final int id;

  ReloadDetail(this.id);
}

/// [SetState] is an event in [CrmDetailBloc] that sets one state of the [CrmDetailStates]
class SetState extends CrmDetailEvents {

}

class ErrorEvent extends CrmDetailEvents {
  final String message;

  ErrorEvent(this.message);
}