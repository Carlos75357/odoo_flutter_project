import 'package:flutter_crm_prove/domain/Task/task.dart';

abstract class TaskDetailStates {}

class TaskDetailInitial extends TaskDetailStates {}

class TaskDetailLoading extends TaskDetailStates {}

class TaskDetailSuccessState extends TaskDetailStates {}

class TaskDetailErrorState extends TaskDetailStates {
  final String error;
  TaskDetailErrorState(this.error);
}

class TaskDetailReload extends TaskDetailStates {}

class TaskDetailUpdate extends TaskDetailStates {
  final Task task;

  TaskDetailUpdate(this.task);
}

class TaskDetailDelete extends TaskDetailStates {
  final int id;

  TaskDetailDelete(this.id);
}

class TaskDetailEdit extends TaskDetailStates {
  bool isEditing;

  TaskDetailEdit(this.isEditing);
}