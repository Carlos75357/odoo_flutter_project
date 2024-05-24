import 'package:flutter_crm_prove/domain/project/project.dart';

abstract class ProjectDetailEvents {}

class LoadProject extends ProjectDetailEvents {
  final Project project;

  LoadProject(this.project);
}

class SaveLeadButtonPressed extends ProjectDetailEvents {
  final Map<String, dynamic> changes;

  SaveLeadButtonPressed(this.changes);
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

class ErrorEvent extends ProjectDetailEvents {
  final String message;

  ErrorEvent(this.message);
}

class NewProjectButtonPressed extends ProjectDetailEvents {}