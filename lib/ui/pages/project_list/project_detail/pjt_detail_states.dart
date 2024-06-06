import '../../../../domain/project/project.dart';

abstract class ProjectDetailStates {
  get data => null;
}

class ProjectDetailInitial extends ProjectDetailStates {}

class ProjectDetailLoading extends ProjectDetailStates {}

class ProjectDetailError extends ProjectDetailStates {}

class ProjectDetailSuccess extends ProjectDetailStates {
  final Project project;

  ProjectDetailSuccess(this.project);
}

class ProjectDetailSort extends ProjectDetailStates {
  final String sortBy;

  @override
  final Map<String, dynamic> data;

  ProjectDetailSort(this.sortBy, this.data);
}

class ProjectDetailLoaded extends ProjectDetailStates{
  final Project project;

  ProjectDetailLoaded(this.project);
}

class ProjectDetailSave extends ProjectDetailStates {
  final Project project;

  ProjectDetailSave(this.project);
}

class ProjectDetailDelete extends ProjectDetailStates {
  final Project project;

  ProjectDetailDelete(this.project);
}

class ProjectDetailEditing extends ProjectDetailStates {
  bool isEditing;

  ProjectDetailEditing(this.isEditing);
}

class ProjectReloaded extends ProjectDetailStates {
  final Project project;

  ProjectReloaded(this.project);
}

class ProjectNew extends ProjectDetailStates {}