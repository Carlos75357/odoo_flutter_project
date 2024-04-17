import '../../../../domain/lead.dart';

abstract class CrmCreateEvents {}

class CreateButtonPressed extends CrmCreateEvents {
  final Lead lead;

  CreateButtonPressed({required this.lead});
}

class CreateEvents extends CrmCreateEvents {
  Map<String, dynamic> values;

  CreateEvents({required this.values});
}

class SetLoadingState extends CrmCreateEvents {

}

class SetSuccessState extends CrmCreateEvents {

}