import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/domain/lead.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_create/crm_create_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_create/crm_create_events.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_create/crm_create_states.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../crm_list_page.dart';

/// [CrmCreatePage] is a page that allows the user to create a new [Lead]
class CrmCreatePage extends StatefulWidget {
  const CrmCreatePage({super.key});

  @override
  CrmCreatePageState createState() => CrmCreatePageState();
}

class CrmCreatePageState extends State<CrmCreatePage> {
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

  /// [changes] is a map that contains the changes made by the user.
  Map<String, dynamic> changes = {
  };

  /// [fieldOptions] is a map that contains the options of the fields.
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

  /// [configData] is the method to set the data of the page.
  Future<void> configData() async {
    BlocProvider.of<CrmCreateBloc>(context).add(SetLoadingState());

    BlocProvider.of<CrmCreateBloc>(context).getFieldsOptions().then((options) {
      if (mounted) {
        setState(() {
          fieldOptions = options;
        });
      }
    }).then((_) {
      if (mounted) {
        BlocProvider.of<CrmCreateBloc>(context).add(SetSuccessState());
      }
    });

    _createDateController.text = _creationDate.toString().substring(0, 10);
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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Guardado con exito"),
            ));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CrmListPage()));
          }
          if (state is CrmCreateError) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Error al guardar"),
            ));
            FirebaseCrashlytics.instance.recordError(state, null, fatal: true);
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
                        _buildField('Nombre', _nameController, 'Text', 'name'),
                        _buildField('Cliente', _clientNameController, 'Client', 'client'),
                        _buildField('Email', _emailController, 'Text', 'email'),
                        _buildField('Telefono', _phoneController, 'Text', 'phone'),
                        _buildField('Fecha de Límite', _dateDeadLineController, 'Date', 'date_deadline'),
                        _buildField('Fecha de Creacion', _createDateController, 'Text' , 'create_date'),
                        _buildField('Compañia', _companyController, 'Company', 'company'),
                        _buildField('Usuario', _userController, 'User', 'user'),
                        _buildField('Etapa', _stageController, 'Stage', 'stage'),
                        _buildField('Prioridad', _priorityController, 'Priority', 'priority'),
                        _buildField('Probabilidad', _probabilityController, 'Text', 'probability'),
                        _buildField('Ingreso esperado', _expectedRevenueController, 'Text', 'expected_revenue'),
                        _buildField('Etiquetas', _tagsController, 'Tags', 'tags'),
                        _buildField('Equipo', _teamController, 'Team', 'team'),
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

  /// [_buildField] method to create each widget for each field.
  Widget _buildField(String title, TextEditingController controller, String type, String caseType) {
    Widget fieldWidget;

    switch (type) {
      case 'Text':
        fieldWidget = _buildTextField(controller, title, type, caseType);
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
        fieldWidget = _buildTextField(controller, title, type, caseType);
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

  /// [_buildTextField] method to create each widget for each field.
  Widget _buildTextField(TextEditingController controller, String title, String type, String caseType) {
    bool isEnable = true;
    if (title.toLowerCase() == 'telefono' || title.toLowerCase() == 'email' || title.toLowerCase() == 'fecha de creacion') {
      isEnable = false;
    }

    if (title.toLowerCase() == 'probabilidad') {
      return _buildSlider();
    } 

    return TextField(
      controller: controller,
      enabled: isEnable,
      decoration: InputDecoration(
        hintText: title,
      ),
      onChanged: (value) {
        if (title.toLowerCase() != 'probabilidad') {
          // addChanges(caseType, value);
        }
      }
    );
  }

  /// [_buildSlider] method to create the slider.
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
              // addChanges('probability', value);
            });
          },
        );
      },
    );
  }

  /// [_buildDropDownField] method to create the dropdown field.
  Widget _buildDropDownField(TextEditingController controller, String type) {
    List<String> list = fieldOptions[type] ?? [];
    // print('Lista: ${list.length}');

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
            value: (type == 'stage') ? 'Nuevo' : null,
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

  /// [_buildDatePickerField] method to create the date picker field.
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
                    // addChanges('create_date', selectedDate);
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

  /// [_buildPriorityField] method to create the priority field.
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

  /// [_buildButton] method to create the button.
  Widget _buildButton() {
    return ElevatedButton(
      onPressed: () {
        updateChangesIfNotEmpty('name', _nameController.text);
        updateChangesIfNotEmpty('email', _emailController.text);
        updateChangesIfNotEmpty('phone', _phoneController.text);
        updateChangesIfNotEmpty('client', _clientNameController.text);
        updateChangesIfNotEmpty('priority', selectedPriority);
        updateChangesIfNotEmpty('date_deadline', _dateDeadLineController.text);
        updateChangesIfNotEmpty('create_date', _createDateController.text);
        updateChangesIfNotEmpty('company', _companyController.text);
        updateChangesIfNotEmpty('user', _userController.text);
        updateChangesIfNotEmpty('stage', _stageController.text);
        updateChangesIfNotEmpty('probability', currentValue);
        updateChangesIfNotEmpty('expected_revenue', _expectedRevenueController.text);

        if (_tagsController.text.isNotEmpty) {
          changes['tags'] = _tagsController.text.split(',').map((tag) => tag.trim()).toList();
        }

        updateChangesIfNotEmpty('team', _teamController.text);

        BlocProvider.of<CrmCreateBloc>(context).add(CreateEvents(values: changes));
      },
      child: const Text('Crear Lead'),
    );
  }

  /// [updateChangesIfNotEmpty] method to update the changes if the value is not empty.
  void updateChangesIfNotEmpty(String key, dynamic value) {
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

  /// [addChanges] method add the changes to the [changes] map.
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
