import 'package:flutter_crm_prove/ui/pages/crm_list/crm_list_page.dart';

import '../../../domain/lead.dart';
/// [CrmListStates] is an abstract class that represents the various states of the [CrmListPage].
abstract class CrmListStates {
  get data => null;
}

/// [CrmListInitial] is an implementation of [CrmListStates] that represents the initial state of the [CrmListPage].
class CrmListInitial extends CrmListStates {}

/// [CrmListLoading] is an implementation of [CrmListStates] that represents the loading state of the [CrmListPage].
class CrmListLoading extends CrmListStates {}

/// [CrmListSuccess] is an implementation of [CrmListStates] that represents the success state of the [CrmListPage].
class CrmListSuccess extends CrmListStates {
  @override
  final Map<String, dynamic> data;

  CrmListSuccess(this.data);
}

/// [CrmListSort] is an implementation of [CrmListStates] that represents the sort state of the [CrmListPage].
class CrmListSort extends CrmListStates {
  final String sortBy;
  @override
  final Map<String, dynamic> data;

  CrmListSort(this.sortBy, this.data);
}

/// [CrmListEmpty] is an implementation of [CrmListStates] that represents the empty state of the [CrmListPage].
class CrmListEmpty extends CrmListStates {}
/// [CrmListDetail] is an implementation of [CrmListStates] that represents the detail state of the [CrmListPage].
class CrmListDetail extends CrmListStates {
  final Lead lead;

  CrmListDetail(this.lead);
}

/// [CrmListError] is an implementation of [CrmListStates] that represents the error state of the [CrmListPage].
class CrmListError extends CrmListStates {
  final String error;
  CrmListError(this.error);
}

/// [CrmNewLead] is an implementation of [CrmListStates] that represents the new lead state of the [CrmListPage].
class CrmNewLead extends CrmListStates {}