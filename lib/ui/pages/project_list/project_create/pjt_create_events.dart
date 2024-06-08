import '../../../../domain/project/project.dart';

abstract class ProjectCreateEvents {}

class CreateButtonPressed extends ProjectCreateEvents {
  final Project project;

  CreateButtonPressed({required this.project});
}

class CreateEvents extends ProjectCreateEvents {
  Map<String, dynamic> values;

  CreateEvents({required this.values});
}

class SetLoadingState extends ProjectCreateEvents {

}

class SetSuccessState extends ProjectCreateEvents {

}