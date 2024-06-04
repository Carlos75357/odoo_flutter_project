abstract class TaskListStates {} // initial, loading, success, error, new, reload

class TaskListInitial extends TaskListStates {}

class TaskListLoading extends TaskListStates {}

class TaskListSuccess extends TaskListStates {}

class TaskListError extends TaskListStates {
  final String message;

  TaskListError(this.message);
}

class TaskListNew extends TaskListStates {}

class TaskListReload extends TaskListStates {}