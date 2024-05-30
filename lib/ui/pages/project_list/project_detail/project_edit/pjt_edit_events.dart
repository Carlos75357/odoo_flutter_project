import '../../../../../domain/project/project.dart';

class ProjectEditEvent {}

class UpdatePjt extends ProjectEditEvent {
  final Project project;
  UpdatePjt({required this.project});
}

class ErrorEvent extends ProjectEditEvent {
  final String error;
  ErrorEvent({required this.error});
}

class SetState extends ProjectEditEvent {

}