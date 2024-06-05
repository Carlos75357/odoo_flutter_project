import '../../../../domain/crm/lead.dart';

/// [CrmDetailStates] is an abstract class that represents the various states of the [CrmDetailPage].
abstract class CrmDetailStates {}
/// [CrmDetailPage] is an implementation of [CrmDetailStates] that represents the detail state of the [CrmDetailPage].
class CrmDetailInitial extends CrmDetailStates {}

/// [CrmDetailLoading] is an implementation of [CrmDetailStates] that represents the loading state of the [CrmDetailPage].
class CrmDetailLoading extends CrmDetailStates {}

/// [CrmDetailReload] is an implementation of [CrmDetailStates] that represents the reload state of the [CrmDetailPage].
class CrmDetailReload extends CrmDetailStates {
  final Lead lead;

  CrmDetailReload(this.lead);
}

/// [CrmDetailSuccess] is an implementation of [CrmDetailStates] that represents the success state of the [CrmDetailPage].
class CrmDetailSuccess extends CrmDetailStates {
  final Lead lead;

  CrmDetailSuccess(this.lead);
}

/// [CrmDetailError] is an implementation of [CrmDetailStates] that represents the error state of the [CrmDetailPage].
class CrmDetailError extends CrmDetailStates {
  final String message;

  CrmDetailError(this.message);
}

/// [CrmDetailEmpty] is an implementation of [CrmDetailStates] that represents the empty state of the [CrmDetailPage].
class CrmDetailEmpty extends CrmDetailStates {}

/// [CrmDetailSave] is an implementation of [CrmDetailStates] that represents the save state of the [CrmDetailPage].
class CrmDetailSave extends CrmDetailStates {
  final Lead lead;

  CrmDetailSave(this.lead);
}

/// [CrmDetailEditing] is an implementation of [CrmDetailStates] that represents the editing state of the [CrmDetailPage].
class CrmDetailEditing extends CrmDetailStates {
  bool isEditing;

  CrmDetailEditing(this.isEditing);
}

/// [CrmDeleteSuccess] is an implementation of [CrmDetailStates] that represents the delete success state of the [CrmDetailPage].
class CrmDeleteSuccess extends CrmDetailStates {}