import '../../../../../domain/Task/task.dart';

abstract class TaskCreateEvents {}

class CreateButtonPressed extends TaskCreateEvents {
  final Task task;

  CreateButtonPressed({required this.task});
}

class CreateEvent extends TaskCreateEvents {
  Map<String, dynamic> values;

  CreateEvent({required this.values});
}

class SetLoadingState extends TaskCreateEvents {

}

class SetSuccessState extends TaskCreateEvents {

}