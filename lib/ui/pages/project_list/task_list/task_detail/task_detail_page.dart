import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/domain/Task/task_formated.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_detail/task_detail_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_detail/task_detail_events.dart';

import '../../../../../domain/Task/task.dart';

class TaskDetailPage extends StatefulWidget {
  Task task;
  TaskDetailPage({super.key, required this.task});

  @override
  _TaskDetailPageState createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _assignedController;
  late TextEditingController _clientController;
  late TextEditingController _companyController;
  late TextEditingController _tagsController;
  late TextEditingController _plannedHoursController;
  late TextEditingController _totalHoursSpentController;
  late TextEditingController _remainingHoursController;
  late TextEditingController _priorityController;
  late TextEditingController _stageController;
  late TaskFormated taskFormated;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _assignedController = TextEditingController();
    _clientController = TextEditingController();
    _companyController = TextEditingController();
    _tagsController = TextEditingController();
    _plannedHoursController = TextEditingController();
    _totalHoursSpentController = TextEditingController();
    _remainingHoursController = TextEditingController();
    _priorityController = TextEditingController();
    _stageController = TextEditingController();
    configData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _assignedController.dispose();
    _clientController.dispose();
    _companyController.dispose();
    _tagsController.dispose();
    _plannedHoursController.dispose();
    _totalHoursSpentController.dispose();
    _remainingHoursController.dispose();
    _priorityController.dispose();
    _stageController.dispose();
    super.dispose();
  }

  Future<void> configData() async {
    BlocProvider.of<TaskDetailBloc>(context).add(SetState());
    BlocProvider.of<TaskDetailBloc>(context).getTaskFormated(widget.task).then((formated) {
      taskFormated = formated;
      setState(() {
        _nameController.text = formated.name;
        _descriptionController.text = formated.description;
        _assignedController.text = formated.assigned_name;
        _clientController.text = formated.client_name;
        _companyController.text = formated.company_names;
        _tagsController.text = formated.tag_names;
        _plannedHoursController.text = formated.planned_hours.toString();
        _totalHoursSpentController.text = formated.total_hours_spent.toString();
        _remainingHoursController.text = formated.remaining_hours.toString();
        _priorityController.text = formated.priority_names;
        _stageController.text = formated.stage_names;
      });
    });
    BlocProvider.of<TaskDetailBloc>(context).getFieldsOptions().then((options) {

    })
  }

  Map<String, List<String>> fieldOptions = {
    'assigned_name': [],
    'client_name': [],
    'tag_names': [],
    'company_names': [],
    'stage_names': [],
  };

  Map<String, List<String>> selectedItems = {
    'assigned_name': [],
    'client_name': [],
    'tag_names': [],
    'company_names': [],
    'stage_names': [],
  };
}