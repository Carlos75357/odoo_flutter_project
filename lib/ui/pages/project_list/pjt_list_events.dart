import '../../../domain/project/project.dart';

abstract class PjtListEvents {}

class LoadAll extends PjtListEvents {}

class PjtSelected extends PjtListEvents {
  final Project project;
  PjtSelected({required this.project});
}

class ReloadAll extends PjtListEvents {}

class CreateNewPjt extends PjtListEvents {}

