/// [CrmCreateStates] is an abstract class that represents the various states of the [CrmCreatePage].
abstract class CrmCreateStates {}

/// [CrmCreateInitial] is the initial state of the [CrmCreatePage].
class CrmCreateInitial extends CrmCreateStates {}

/// [CrmCreateLoading] represents the loading state of the [CrmCreatePage].
class CrmCreateLoading extends CrmCreateStates {}

/// [CrmCreateSuccess] represents the success state of the [CrmCreatePage].
class CrmCreateSuccess extends CrmCreateStates {}

/// [CrmCreateError] represents the error state of the [CrmCreatePage].
class CrmCreateError extends CrmCreateStates {
  final String error;

  CrmCreateError(this.error);
}

/// [CrmCreateDone] represents the done state of the [CrmCreatePage].
class CrmCreateDone extends CrmCreateStates {}
