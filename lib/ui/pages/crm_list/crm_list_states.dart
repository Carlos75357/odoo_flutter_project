abstract class CrmListStates {}

class CrmListInitial extends CrmListStates {}

class CrmListLoading extends CrmListStates {}

class CrmListSuccess extends CrmListStates {
  final Map<String, dynamic> data;

  CrmListSuccess(this.data);
}

class CrmListSort extends CrmListStates {
  final String sortBy;
  Map<String, dynamic> data = {};

  CrmListSort(this.sortBy, this.data);
}

class CrmListEmpty extends CrmListStates {}

class CrmListDetail extends CrmListStates {
  final int id;

  CrmListDetail(this.id);
}

class CrmListError extends CrmListStates {
  final String error;
  CrmListError(this.error);
}