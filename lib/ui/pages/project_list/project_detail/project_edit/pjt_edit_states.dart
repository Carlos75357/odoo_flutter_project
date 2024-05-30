class ProjectEditState {} // loading, success, error, inital

class ProjectEditSuccess extends ProjectEditState {}

class ProjectEditError extends ProjectEditState {
  String message;

  ProjectEditError(this.message);
}

class ProjectEditInitial extends ProjectEditState {}

class ProjectEditLoading extends ProjectEditState {}

class ProjectEditUpdate extends ProjectEditState {
  Map<String, dynamic> data;
  ProjectEditUpdate(this.data);
}