import '../../../../domain/Task/task.dart';

abstract class TaskListEvents {}

class TaskSelected extends TaskListEvents {
  final Task task;
  TaskSelected(this.task);
}

class TaskListLoad extends TaskListEvents {}

class TaskListErrorEvent extends TaskListEvents {
  final String message;
  TaskListErrorEvent(this.message);
}

class TaskListReloadEvent extends TaskListEvents {}

class TaskListNewButtonPressed extends TaskListEvents {}

class ChangeFilter extends TaskListEvents {
  final String filter;
  ChangeFilter(this.filter);
}