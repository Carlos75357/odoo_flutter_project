abstract class CrmCreateStates {}

class CrmCreateInitial extends CrmCreateStates {}

class CrmCreateLoading extends CrmCreateStates {}

class CrmCreateSuccess extends CrmCreateStates {}

class CrmCreateError extends CrmCreateStates {
  final String error;

  CrmCreateError(this.error);
}
