import 'package:flutter_crm_prove/domain/lead.dart';
import 'package:flutter_crm_prove/domain/lead_formated.dart';

abstract class CrmDetailEvents {}

class LoadLead extends CrmDetailEvents {
  final Lead lead;

  LoadLead(this.lead);
}

class SaveLeadButtonPressed extends CrmDetailEvents {
  final Map<String, dynamic> changes;

  SaveLeadButtonPressed(this.changes);
}

class DeleteLeadButtonPressed extends CrmDetailEvents {
  final Lead lead;

  DeleteLeadButtonPressed(this.lead);
}

class ToggleEditButtonPressed extends CrmDetailEvents {

}