import '../../../domain/lead.dart';

abstract class CrmListStates {
  get data => null;
}

class CrmListInitial extends CrmListStates {}

class CrmListLoading extends CrmListStates {}

class CrmListSuccess extends CrmListStates {
  @override
  final Map<String, dynamic> data;

  CrmListSuccess(this.data);
}

class CrmListSort extends CrmListStates {
  final String sortBy;
  @override
  final Map<String, dynamic> data;

  CrmListSort(this.sortBy, this.data);
}

class CrmListEmpty extends CrmListStates {}

class CrmListDetail extends CrmListStates {
  final Lead lead;

  CrmListDetail(this.lead);
}

class CrmListError extends CrmListStates {
  final String error;
  CrmListError(this.error);
}

class CrmNewLead extends CrmListStates {}