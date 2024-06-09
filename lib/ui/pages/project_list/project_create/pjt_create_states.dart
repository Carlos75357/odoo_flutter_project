abstract class ProjectCreateStates {}

class ProjectCreateInitial extends ProjectCreateStates {}

class ProjectCreateLoading extends ProjectCreateStates {}

class ProjectCreateSuccess extends ProjectCreateStates {}

class ProjectCreateError extends ProjectCreateStates {
  final String error;

  ProjectCreateError(this.error);
}

class ProjectCreateDone extends ProjectCreateStates {}
