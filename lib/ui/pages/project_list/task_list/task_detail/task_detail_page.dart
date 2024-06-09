import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/domain/Task/task_formated.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_page.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_detail/task_detail_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_detail/task_detail_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_detail/task_detail_states.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../../domain/Task/task.dart';
import '../../../../../domain/project/project.dart';

class TaskDetailPage extends StatefulWidget {
  Project project;
  Task task;
  TaskDetailPage({super.key, required this.task, required this.project});

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
  List<String>? tagStages;

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

  Future<void> configData() async {
    BlocProvider.of<TaskDetailBloc>(context).add(SetState());
    BlocProvider.of<TaskDetailBloc>(context).getTaskFormated(widget.task).then((formated) {
      taskFormated = formated;
      setState(() {
        _nameController.text = formated.name ?? '';
        _descriptionController.text = formated.description ?? '';
        _assignedController.text = formated.assignedNames?.join(', ') ?? '';
        _clientController.text = formated.clientName ?? '';
        _companyController.text = formated.companyName ?? '';
        _tagsController.text = formated.tagNames?.join(', ') ?? '';
        _plannedHoursController.text = formated.plannedHours.toString();
        _totalHoursSpentController.text = formated.totalHoursSpent.toString();
        _remainingHoursController.text = formated.remainingHours.toString();
        _priorityController.text = formated.priority ?? '';
        _stageController.text = formated.stageName ?? '';
      });
    });
    BlocProvider.of<TaskDetailBloc>(context).getFieldsOptions().then((options) {
      BlocProvider.of<TaskDetailBloc>(context).add(TaskDetailSuccess());
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Detalle de la tarea: ${widget.task.name}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Raleway',
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
      body: BlocListener<TaskDetailBloc, TaskDetailStates> (
        listener: (context, state) {
          if (state is TaskDetailError) {
            FirebaseCrashlytics.instance.recordError(state, null, fatal: true);
          } else if (state is TaskDetailReload) {
            configData();
          }
        },
        child: BlocBuilder<TaskDetailBloc, TaskDetailStates>(
          builder: (context, state) {
            if (state is TaskDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskDetailSuccessState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildField('Tarea', _nameController),
                      _buildField('Descripción', _descriptionController, isHtml: true),
                      _buildField('Asignado', _assignedController),
                      _buildField('Cliente', _clientController),
                      _buildField('Compania', _companyController),
                      _buildField('Etiquetas', _tagsController),
                      _buildField('Horas Planeadas', _plannedHoursController),
                      _buildField('Horas Totales', _totalHoursSpentController),
                      _buildField('Horas Restantes', _remainingHoursController),
                      _buildField('Prioridad', _priorityController),
                      _buildField('Etapa', _stageController),
                    ],
                  ),
                )
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {bool isHtml = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        _buildBody(label, controller, isHtml: isHtml),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBody(String label, TextEditingController controller, {bool isHtml = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        isHtml
            ? Html(
          data: controller.text,
          style: {
            "html": Style(
              backgroundColor: Colors.black12,
            ),
          },
        )
            : TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Introduce el texto aquí',
          ),
        ),
      ],
    );
  }

}