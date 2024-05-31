class ProjectEditStates {} // loading, success, error, inital

class ProjectEditSuccess extends ProjectEditStates {}

class ProjectEditError extends ProjectEditStates {
  String message;

  ProjectEditError(this.message);
}

class ProjectEditInitial extends ProjectEditStates {}

class ProjectEditLoading extends ProjectEditStates {}

class ProjectEditUpdate extends ProjectEditStates {
  Map<String, dynamic> data;
  ProjectEditUpdate(this.data);
}