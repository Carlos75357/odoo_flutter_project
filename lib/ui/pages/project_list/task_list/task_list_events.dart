import '../../../../domain/Task/task.dart';

abstract class TaskListEvents {}

class TaskSelected extends TaskListEvents {
  final Task task;
  TaskSelected(this.task);
}

class TaskListLoaded extends TaskListEvents {
  final List<Task> tasks;
  TaskListLoaded(this.tasks);
}

class TaskListError extends TaskListEvents {
  final String message;
  TaskListError(this.message);
}

class TaskListReload extends TaskListEvents {
  final List<Task> tasks;
  TaskListReload(this.tasks);
}

class TaskListNewButtonPressed extends TaskListEvents {}

class ChangeFilter extends TaskListEvents {
  final String filter;
  ChangeFilter(this.filter);
}