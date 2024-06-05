abstract class ModuleState {}

class ModuleStateInitial extends ModuleState {}

class ModuleStateLoading extends ModuleState {}

class ModuleStateSuccess extends ModuleState {
  final int id;

  ModuleStateSuccess(this.id);
}

class ModuleStateError extends ModuleState {
  final String message;

  ModuleStateError(this.message);
}