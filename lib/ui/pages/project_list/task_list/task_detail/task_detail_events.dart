abstract class TaskDetailEvents {}

class TaskDetailError extends TaskDetailEvents {
  final String message;

  TaskDetailError(this.message);
}

class TaskDetailSuccess extends TaskDetailEvents {}

class TaskDetailLoadingEvent extends TaskDetailEvents {}

class TaskDetailInit extends TaskDetailEvents {}

class TaskDetailDeleteButtonPressed extends TaskDetailEvents {}

class SetState extends TaskDetailEvents {}