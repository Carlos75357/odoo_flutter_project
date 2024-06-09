import 'package:flutter_crm_prove/domain/project/project_formated.dart';

import '../../../../../domain/project/project.dart';

class ProjectEditEvent {
  get projectF => null;
}

class UpdatePjt extends ProjectEditEvent {
  @override
  final ProjectFormated projectF;
  UpdatePjt({required this.projectF});
}

class ErrorEvent extends ProjectEditEvent {
  final String error;
  ErrorEvent({required this.error});
}

class SetState extends ProjectEditEvent {
  final Project project;

  SetState({required this.project});
}

class StateSuccess extends ProjectEditEvent {

}