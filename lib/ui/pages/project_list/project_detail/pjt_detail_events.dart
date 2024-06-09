import 'package:flutter_crm_prove/domain/project/project.dart';

import '../../../../domain/Task/task.dart';

abstract class ProjectDetailEvents {}

class LoadProject extends ProjectDetailEvents {
  final Project project;

  LoadProject(this.project);
}

class SaveProjectButtonPressed extends ProjectDetailEvents {
  final Map<String, dynamic> changes;

  SaveProjectButtonPressed(this.changes);
}

class UnlinkProjectButtonPressed extends ProjectDetailEvents {
  final int id;

  UnlinkProjectButtonPressed(this.id);
}

class ToggleEditButtonPressed extends ProjectDetailEvents {}

class ReloadDetail extends ProjectDetailEvents {
  final int id;

  ReloadDetail(this.id);
}

class SetState extends ProjectDetailEvents {

}

class SetSuccessState extends ProjectDetailEvents {}

class ErrorEvent extends ProjectDetailEvents {
  final String message;

  ErrorEvent(this.message);
}

class NewTaskButtonPressed extends ProjectDetailEvents {}

class ChangeFilter extends ProjectDetailEvents {
  final String filter;
  ChangeFilter(this.filter);
}


class TaskSelected extends ProjectDetailEvents {
  final Task task;
  TaskSelected({required this.task});
}