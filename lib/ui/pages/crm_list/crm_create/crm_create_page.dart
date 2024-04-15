import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_create/crm_create_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_create/crm_create_events.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_create/crm_create_states.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../../../domain/lead.dart';

class CrmCreatePage extends StatefulWidget {
  const CrmCreatePage({Key? key}) : super(key: key);

  @override
  _CrmCreatePageState createState() => _CrmCreatePageState();
}

class _CrmCreatePageState extends State<CrmCreatePage> {
  late TextEditingController _nameController;
  late TextEditingController _clientNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _companyController;
  late TextEditingController _userController;
  late TextEditingController _dateDeadLineController;
  late TextEditingController _teamController;
  late TextEditingController _expectedRevenueController;
  late TextEditingController _tagsController;
  late TextEditingController _priorityController;
  late TextEditingController _probabilityController;
  late TextEditingController _createDateController;
  late TextEditingController _stageController;

  late DateTime _creationDate;
  double currentValue = 0;

  int selectedPriority = 0;

  Map<String, dynamic> changes = {
  };

  Map<String, List<String>> fieldOptions = {
    'stage': [],
    'user': [],
    'company': [],
    'client': [],
    'tags': [],
    'team': [],
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _clientNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _companyController = TextEditingController();
    _userController = TextEditingController();
    _dateDeadLineController = TextEditingController();
    _teamController = TextEditingController();
    _expectedRevenueController = TextEditingController();
    _tagsController = TextEditingController();
    _priorityController = TextEditingController();
    _probabilityController = TextEditingController();
    _createDateController = TextEditingController();
    _stageController = TextEditingController();
    _creationDate = DateTime.now();
    configData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _clientNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _userController.dispose();
    _dateDeadLineController.dispose();
    _teamController.dispose();
    _expectedRevenueController.dispose();
    _tagsController.dispose();
    _priorityController.dispose();
    _probabilityController.dispose();
    _createDateController.dispose();
    _stageController.dispose();
    super.dispose();
  }

  Future<void> configData() async {
    BlocProvider.of<CrmCreateBloc>(context).add(SetLoadingState());

    BlocProvider.of<CrmCreateBloc>(context).getFieldsOptions().then((options) {
      setState(() {
        fieldOptions = options;
        print(fieldOptions);
      });
    }).then((_) {
      BlocProvider.of<CrmCreateBloc>(context).add(SetSuccessState());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nuevo Lead'),
        backgroundColor: Colors.purpleAccent.shade400,
      ),
      body: BlocListener<CrmCreateBloc, CrmCreateStates>(
        listener: (context, state) {
          if (state is CrmCreateDone) {

          }
        },
        child: BlocBuilder<CrmCreateBloc, CrmCreateStates>(
          builder: (context, state) {
            if (state is CrmCreateLoading) {
              return const LinearProgressIndicator();
            }
            if (state is CrmCreateSuccess) {
              return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildField('Nombre', _nameController, 'Text'),
                        _buildField('Cliente', _clientNameController, 'Client'),
                        _buildField('Email', _emailController, 'Text'),
                        _buildField('Telefono', _phoneController, 'Text'),
                        _buildField('Fecha de Límite', _dateDeadLineController, 'Date'),
                        _buildField('Fecha de Creacion', _createDateController, 'Text'),
                        _buildField('Compañia', _companyController, 'Company'),
                        _buildField('Usuario', _userController, 'User'),
                        _buildField('Etapa', _stageController, 'Stage'),
                        _buildField('Prioridad', _priorityController, 'Priority'),
                        _buildField('Probabilidad', _probabilityController, 'Text'),
                        _buildField('Ingreso esperado', _expectedRevenueController, 'Text'),
                        _buildField('Etiquetas', _tagsController, 'Tags'),
                        _buildField('Equipo', _teamController, 'Team'),
                        const SizedBox(height: 8),
                        _buildButton(),
                        const SizedBox(height: 8),
                      ],
                    ),
                  )
              );
            }
            return const LinearProgressIndicator();
          }
        )
      )

    );
  }

  Widget _buildField(String title, TextEditingController controller, String type) {
    Widget fieldWidget;

    switch (type) {
      case 'Text':
        fieldWidget = _buildTextField(controller, title, type);
        break;
      case 'Date':
        fieldWidget = _buildDatePickerField(controller);
        break;
      case 'Tags' || 'Client' || 'Company' || 'User' || 'Stage' || 'Team':
        fieldWidget = _buildDropDownField(controller, type.toLowerCase());
        break;
      case 'Priority':
        fieldWidget = _buildPriorityField(title, controller);
      default:
        fieldWidget = _buildTextField(controller, title, type);
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

  Widget _buildTextField(TextEditingController controller, String title, String type) {
    bool isEnable = true;
    if (title.toLowerCase() == 'telefono' || title.toLowerCase() == 'email' || title.toLowerCase() == 'fecha de creacion') {
      isEnable = false;
    }

    // Si el título es "probabilidad", retorna un Slider en lugar de un TextField
    if (title.toLowerCase() == 'probabilidad') {
      return _buildSlider();
    }

    return TextField(
      controller: controller,
      enabled: isEnable,
      decoration: InputDecoration(
        hintText: title,
      ),
    );
  }

  Widget _buildSlider() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Slider(
          value: currentValue,
          min: 0,
          max: 100,
          divisions: 100,
          label: currentValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              currentValue = value;
            });
          },
        );
      },
    );
  }

  Widget _buildDropDownField(TextEditingController controller, String type) {
    print(fieldOptions[type]);
    List<String> list = fieldOptions[type] ?? [];

    if (type == 'tags') {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.purpleAccent[400]!,
            width: 1,
          )
        ),
        child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: MultiSelectDialogField(
           title: const Text('Etiquetas'),
           items: list.map((e) => MultiSelectItem(e, e)).toList(),
           onConfirm: (results) {
             setState(() {
               controller.text = results.map((e) => e.toString()).join(', ');
             });
           },
         ),
        )
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.purpleAccent[400]!,
            width: 1,
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            isExpanded: true,
            hint: const Text('Etiquetas'),
            items: list.map<DropdownMenuItem<String>>((String value) {
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
        )
      );
    }
  }

  Widget _buildDatePickerField(TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[400]!,
          width: 1.5,
        ),
      ),
      child: Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              ).then((selectedDate) {
                if (selectedDate != null) {
                  setState(() {
                    controller.text = selectedDate.toString();
                  });
                }
              });
            },
            child: IgnorePointer(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          )
      ),
    );
  }

  Widget _buildPriorityField(String label, TextEditingController controller) {
    List<Widget> stars = List.generate(
      3,
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
            if (selectedPriority != newPriority) {
              addChanges('priority', selectedPriority);
            }
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

  Widget _buildButton() {
    return ElevatedButton(
      onPressed: () {
        changes['name'] = _nameController.text.isEmpty ? null : _nameController.text;
        changes['email'] = _emailController.text.isEmpty ? null : _emailController.text;
        changes['phone'] = _phoneController.text.isEmpty ? null : _phoneController.text;
        changes['client'] = _clientNameController.text.isEmpty ? null : _clientNameController.text;
        changes['priority'] = selectedPriority;
        changes['date_deadline'] = _dateDeadLineController.text.isEmpty ? null : _dateDeadLineController.text;
        changes['create_date'] = _createDateController.text.isEmpty ? null : _createDateController.text;
        changes['company'] = _companyController.text.isEmpty ? null : _companyController.text;
        changes['user'] = _userController.text.isEmpty ? null : _userController.text;
        changes['stage'] = _stageController.text.isEmpty ? null : _stageController.text;
        changes['probability'] = _probabilityController.text.isEmpty ? null : _probabilityController.text;
        changes['expected_revenue'] = _expectedRevenueController.text.isEmpty ? null : _expectedRevenueController.text;
        changes['tags'] = _tagsController.text.isEmpty ? null : _tagsController.text.split(',').map((tag) => tag.trim()).toList();
        changes['team'] = _teamController.text.isEmpty ? null : _teamController.text;

        print(changes);

        BlocProvider.of<CrmCreateBloc>(context).add(CreateEvents(values: changes));
      },
      child: const Text('Crear Lead'),
    );
  }

  void addChanges(String key, dynamic value) {
    for (dynamic value in changes.values) {
      if (value is List) {
        if (value.contains(key)) {
          changes[key] = value;
        }
      }
    }
  }
}
