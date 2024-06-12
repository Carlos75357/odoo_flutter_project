import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_page.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_create/task_create_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_create/task_create_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_create/task_create_states.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../../../../domain/project/project.dart';
import '../../pjt_list_page.dart';

class TaskCreatePage extends StatefulWidget {
  final Project project;
  final String projectName;
  const TaskCreatePage({Key? key, required this.projectName, required this.project}) : super(key: key);

  @override
  TaskCreatePageState createState() => TaskCreatePageState();
}

class TaskCreatePageState extends State<TaskCreatePage> {
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
  int selectedPriority = 0;

  @override
  void initState() {
    super.initState();
    configData();
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

  void configData() async {
    BlocProvider.of<TaskCreateBloc>(context).add(SetLoadingState());

    BlocProvider.of<TaskCreateBloc>(context).getFieldsOptions().then((options) {
      setState(() {
        fieldOptions = options;
      });
      if (mounted) {
      }
    }).then((_) {
      BlocProvider.of<TaskCreateBloc>(context).add(SetSuccessState());
      if (mounted) {
      }
    });
  }

  Map<String, dynamic> changes = {};

  Map<String, List<String>> fieldOptions = {
    'assigned_name': [],
    'client_name': [],
    'tag_names': [],
    'company_names': [],
    'stage_names': [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Crear Tarea para el proyecto ${widget.projectName}',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProjectDetailPage(project: widget.project)));
          },
        ),
      ),
      body: BlocListener<TaskCreateBloc, TaskCreateStates>(
        listener: (context, state) {
          if (state is TaskCreateDone) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Guardado con éxito"),
            ));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProjectDetailPage(project: widget.project)));
          }
          if (state is TaskCreateError) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Error al guardar"),
            ));
            FirebaseCrashlytics.instance.recordError(state, null, fatal: true);
          }
        },
        child: BlocBuilder<TaskCreateBloc, TaskCreateStates>(
          builder: (context, state) {
            if (state is TaskCreateLoading) {
              return const LinearProgressIndicator();
            }
            if (state is TaskCreateSuccess) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildField('Nombre', _nameController, 'Text', 'name'),
                      _buildField('Descripción', _descriptionController, 'Description', 'description'),
                      _buildField('Asignado a', _assignedController, 'DropDown', 'assigned_name'),
                      _buildField('Cliente', _clientController, 'DropDown', 'client_name'),
                      _buildField('Etiquetas', _tagsController, 'MultiSelect', 'tag_names'),
                      _buildField('Compañías', _companyController, 'DropDown', 'company_names'),
                      _buildField('Prioridad', _priorityController, 'Priority', 'priority'),
                      _buildField('Etapa', _stageController, 'DropDown', 'stage_names'),
                      _buildField('Horas Planificadas', _plannedHoursController, 'Text', 'planned_hours'),
                      _buildField('Horas Totales', _totalHoursSpentController, 'Text', 'total_hours'),
                      _buildField('Horas Restantes', _remainingHoursController, 'Text', 'remaining_hours'),
                      _buildButton(),
                    ],
                  ),
                ),
              );
            } else {
              return const RefreshProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _buildField(String title, TextEditingController controller, String type, String caseType) {
    Widget fieldWidget;

    switch (type) {
      case 'Text':
        fieldWidget = _buildTextField(controller, title);
        break;
      case 'MultiSelect':
        fieldWidget = _MultiSelectDialog(controller, type.toLowerCase());
        break;
      case 'DropDown':
        fieldWidget = _buildDropDownField(controller, caseType);
        break;
      case 'Description':
        fieldWidget = _buildDescriptionField(controller, caseType);
        break;
      case 'Priority':
        fieldWidget = _buildPriorityField(controller, caseType);
      default:
        fieldWidget = _buildTextField(controller, title);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        fieldWidget,
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String title) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: title,
      ),
      onChanged: (value) {
        if (title.toLowerCase() != 'probabilidad') {
          // addChanges(caseType, value);
        }
      },
    );
  }

  Widget _buildDescriptionField(TextEditingController controller, String title) {
    return TextField(
      controller: controller,
      maxLines: 10,
      decoration: InputDecoration(
        hintText: title,
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
      },
    );
  }

  Widget _MultiSelectDialog(TextEditingController controller, String type) {
    List<String> options = fieldOptions[type] ?? [];
    print('FieldOptions: $options');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[400]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: MultiSelectDialogField(
          items: options.map((option) => MultiSelectItem(option, option)).toList(),
          title: Text('Select $type'),
          onConfirm: (results) {
            setState(() {
              controller.text = results.map((e) => e.toString()).join(', ');
            });
          },
        ),
      ),
    );
  }

  Widget _buildDropDownField(TextEditingController controller, String type) {
    fieldOptions[type]!.add('Ninguno');

    List<String> options = fieldOptions[type] ?? [];
    print('FieldOptions: $options');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[400]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: DropdownButtonFormField(
          isExpanded: true,
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              controller.text = value.toString();
            });
          },
        ),
      ),
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
      onPressed: () async {
        _updateChangesIfNotEmpty('name', _nameController.text);
        _updateChangesIfNotEmpty('assigned_name', _assignedController.text);
        _updateChangesIfNotEmpty('client_name', _clientController.text);
        _updateChangesIfNotEmpty('planned_hours', _plannedHoursController.text);
        _updateChangesIfNotEmpty('total_hours', _totalHoursSpentController.text);
        _updateChangesIfNotEmpty('company_names', _companyController.text);
        _updateChangesIfNotEmpty('remaining_hours', _remainingHoursController.text);
        _updateChangesIfNotEmpty('stage_names', _stageController.text);
        _updateChangesIfNotEmpty('priority', selectedPriority);

        if (_tagsController.text.isNotEmpty) {
          changes['tag_names'] = _tagsController.text.split(',').map((tag) => tag.trim()).toList();
        }

        BlocProvider.of<TaskCreateBloc>(context).add(CreateEvent(values: changes));
      },
      child: const Text('Crear Tarea'),
    );
  }

  Widget _buildPriorityField(TextEditingController controller, String label) {
    List<Widget> stars = List.generate(
      1,
          (index) => IconButton(
        onPressed: () {
          int newPriority = index + 1;
          setState(() {
            if (selectedPriority == newPriority) {
              selectedPriority = 0;
              controller.text = '';
            } else {
              selectedPriority = newPriority;
              controller.text = '★' * selectedPriority;
            }
            // if (selectedPriority != newPriority) {
            // }
            // addChanges('priority', selectedPriority);
          });
        },
        icon: Icon(
          index < selectedPriority ? Icons.star : Icons.star_border,
          color: Colors.yellow,
          size: 20,
        ),
      ),
    );

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: stars,
        ),
      ],
    );
  }

  void _updateChangesIfNotEmpty(String key, dynamic value) {
    if (value.runtimeType == String) {
      if (value.isNotEmpty) {
        changes[key] = value;
      }
    } else {
      if (value != null) {
        changes[key] = value;
      }
    }
  }
}
