import '../../../domain/project/project.dart';

abstract class PjtListStates {
  get data => null;
}

class PjtListInitial extends PjtListStates {}

class PjtListLoading extends PjtListStates {}

class PjtListSuccess extends PjtListStates {
  @override
  final Map<String, dynamic> data;

  PjtListSuccess(this.data);
}

class PjtDetail extends PjtListStates {
  final Project project;

  PjtDetail(this.project);
}

class PjtListError extends PjtListStates {
  String message;

  PjtListError(this.message);
}

class PjtNew extends PjtListStates {}

class PjtReload extends PjtListStates {}