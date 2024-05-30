import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_bloc.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../../domain/project/project.dart';

class EditPopupWidget extends StatefulWidget {
  final Project project;
  final ValueChanged<Project> onSave;

  const EditPopupWidget({
    Key? key,
    required this.project,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditPopupWidgetState createState() => _EditPopupWidgetState();
}

class _EditPopupWidgetState extends State<EditPopupWidget> {
  late TextEditingController _nameController;
  late TextEditingController _taskNameController;
  late TextEditingController _clientController;
  late TextEditingController _tagsController;
  late TextEditingController _companyController;
  late TextEditingController _responsibleController;
  late TextEditingController _projectStageController;
  late String _responsibleValue;
  late String _projectStageValue;
  late ValueNotifier<bool> _isEdited;

  Map<String, List<String>> fieldOptions = {
    'tags': [],
    'responsible': [],
    'project_stage': [],
    'client': [],
    'company': [],
  };

  Map<String, List<String>> selectedItems = {
    'tags': [],
    'responsible': [],
    'project_stage': [],
    'client': [],
    'company': [],
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project.name);
    _taskNameController = TextEditingController();
    _clientController = TextEditingController();
    _tagsController = TextEditingController();
    _companyController = TextEditingController();
    _responsibleController = TextEditingController();
    _projectStageController = TextEditingController();
    _responsibleValue = '';
    _projectStageValue = '';
    _isEdited = ValueNotifier<bool>(false);

    _nameController.addListener(_updateEdited);
    _taskNameController.addListener(_updateEdited);
    _clientController.addListener(_updateEdited);
    _tagsController.addListener(_updateEdited);
    _companyController.addListener(_updateEdited);
    _responsibleController.addListener(_updateEdited);
    _projectStageController.addListener(_updateEdited);

    configData();
  }

  Future<void> configData() async {
    // los tipos seleciconados
    selectedItems['tags'] = widget.project.tagIds?.map((e) => e.toString()).toList() ?? [];
    selectedItems['responsible'] = [widget.project.userId ?? ''];
    selectedItems['project_stage'] = [widget.project.status ?? ''];
    selectedItems['client'] = [widget.project.partnerId ?? ''];
    selectedItems['company'] = [widget.project.companyId ?? ''];

    // todos los valores que se pueden seleccionar
    fieldOptions = await BlocProvider.of<ProjectDetailBloc>(context).getDataList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _taskNameController.dispose();
    _clientController.dispose();
    _tagsController.dispose();
    _companyController.dispose();
    _isEdited.dispose();
    super.dispose();
  }

  void _updateEdited() {
    _isEdited.value = _nameController.text != widget.project.name ||
        _taskNameController.text.isNotEmpty ||
        _clientController.text.isNotEmpty ||
        _tagsController.text.isNotEmpty ||
        _companyController.text.isNotEmpty ||
        _responsibleController.text.isNotEmpty ||
        _projectStageController.text.isNotEmpty ||
        _responsibleValue.isNotEmpty ||
        _projectStageValue.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Project Details"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildField("Name", _nameController, 'Text', 'name'),
            _buildField("Task Name", _taskNameController, 'Text', 'task_name'),
            _buildField("Client", _clientController, 'Dropdown', 'client'),
            _buildField("Tags", _tagsController, 'MultiSelect', 'tags'),
            _buildField("Company", _companyController, 'Dropdown', 'company'),
            _buildField("Responsible", _responsibleController, 'Dropdown', 'responsible'),
            _buildField("Project Stage", _projectStageController, 'Dropdown', 'project_stage'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _isEdited,
          builder: (context, isEdited, child) {
            return ElevatedButton(
              onPressed: isEdited
                  ? () {
                widget.onSave(Project(
                  id: widget.project.id,
                  name: _nameController.text,
                  taskName: _taskNameController.text,
                  partnerId: _clientController.text,
                  tagIds: _tagsController.text.split(',').map((tag) => int.parse(tag)).toList(),
                  userId: _responsibleValue,
                  companyId: _companyController.text,
                  status: _projectStageValue,
                ));
                Navigator.of(context).pop();
              }
                  : null,
              child: const Text("Save"),
            );
          },
        ),
      ],
    );
  }


  Widget _buildField(String label, TextEditingController controller, String caseType, String type) {
    Widget fieldWidget;

    switch (caseType) {
      case 'Dropdown':
        fieldWidget = _buildDropdownField(controller, caseType.toLowerCase(), type);
        break;
      case 'MultiSelect':
        fieldWidget = _buildMultiSelectField(controller, caseType.toLowerCase(), type);
        break;
      default:
        fieldWidget = _buildTextField(controller, label);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        fieldWidget,
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
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
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
        )
      ),
    );
  }

  Widget _buildMultiSelectField(TextEditingController controller, String label, String type) {

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
          initialValue: selectedItems[type]?.toList() ?? [],
          title: Text('Select $label'),
          buttonIcon: const Icon(Icons.arrow_drop_down),
          buttonText: Text('Select $label'),
          onConfirm: (results) {
            setState(() {
              selectedItems[type] = results.map((result) => result.toString()).toList();
            });
          }
        )
      )
    );
  }

  Widget _buildDropdownField(TextEditingController controller, String label, String type) {

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
          value: options,
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedItems[type] = [value.toString()];
            });
          },
        ),
      ),
    );
  }
}