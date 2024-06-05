
import '../../../../domain/crm/lead.dart';

/// [CrmCreateEvents] is an abstract class that defines events related to the [CrmCreatePage].
abstract class CrmCreateEvents {}

/// [CreateButtonPressed] is an event that triggers the creation of a new lead.
class CreateButtonPressed extends CrmCreateEvents {
  final Lead lead;

  CreateButtonPressed({required this.lead});
}

/// [CreateButtonPressed] is an event that triggers the creation of a new lead.
class CreateEvents extends CrmCreateEvents {
  Map<String, dynamic> values;

  CreateEvents({required this.values});
}

/// [SetLoadingState] is an event that triggers the creation of a new lead.
class SetLoadingState extends CrmCreateEvents {

}

/// [SetSuccessState] is an event that triggers the creation of a new lead.
class SetSuccessState extends CrmCreateEvents {

}