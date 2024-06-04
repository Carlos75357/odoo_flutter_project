abstract class TaskDetailEvents {}

class TaskDetailError extends TaskDetailEvents {
  final String message;

  TaskDetailError(this.message);
}

class TaskDetailSuccess extends TaskDetailEvents {}

class TaskDetailLoading extends TaskDetailEvents {}

class TaskDetailInit extends TaskDetailEvents {}

class TaskDetailToggleEdit extends TaskDetailEvents {}

class TaskDetailUpdateButtonPressed extends TaskDetailEvents {}

class TaskDetailDeleteButtonPressed extends TaskDetailEvents {}

class SetState extends TaskDetailEvents {}