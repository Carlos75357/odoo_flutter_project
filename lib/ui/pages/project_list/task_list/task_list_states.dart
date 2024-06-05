import '../../../../domain/Task/task.dart';

abstract class TaskListStates {
  get data => null;
} // initial, loading, success, error, new, reload

class TaskListInitial extends TaskListStates {}

class TaskListLoading extends TaskListStates {}

class TaskListSuccess extends TaskListStates {
  @override
  Map<String, dynamic> data;
  TaskListSuccess(this.data);
}

class TaskListError extends TaskListStates {
  final String message;

  TaskListError(this.message);
}

class TaskListDetail extends TaskListStates {
  Task task;
  TaskListDetail(this.task);
}

class TaskListNew extends TaskListStates {}

class TaskListReload extends TaskListStates {}

class TaskListSort extends TaskListStates {
  @override
  final Map<String, dynamic> data;
  final String sortBy;

  TaskListSort(this.data, this.sortBy);
}