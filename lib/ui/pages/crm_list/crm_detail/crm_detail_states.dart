import '../../../../domain/lead.dart';

abstract class CrmDetailStates {}

class CrmDetailInitial extends CrmDetailStates {}

class CrmDetailLoading extends CrmDetailStates {}

class CrmDetailSuccess extends CrmDetailStates {
  final Lead lead;

  CrmDetailSuccess(this.lead);
}

class CrmDetailError extends CrmDetailStates {
  final String message;

  CrmDetailError(this.message);
}

class CrmDetailEmpty extends CrmDetailStates {}

class CrmDetailSave extends CrmDetailStates {
  final Lead lead;

  CrmDetailSave(this.lead);
}

class CrmDetailEditing extends CrmDetailStates {
  bool isEditing;

  CrmDetailEditing(this.isEditing);
}