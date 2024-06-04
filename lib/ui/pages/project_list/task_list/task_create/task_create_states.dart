abstract class TaskCreateStates {}

class TaskCreateInitial extends TaskCreateStates {}

class TaskCreateLoading extends TaskCreateStates {}

class TaskCreateSuccess extends TaskCreateStates {}

class TaskCreateError extends TaskCreateStates {
  final String error;

  TaskCreateError(this.error);
}

class TaskCreateDone extends TaskCreateStates {}
