abstract class ModuleEvent {}

class ModuleEventButtonPressed extends ModuleEvent {
  final int id;

  ModuleEventButtonPressed(this.id);
}