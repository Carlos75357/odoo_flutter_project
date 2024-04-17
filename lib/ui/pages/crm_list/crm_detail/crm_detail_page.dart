import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_detail/crm_detail_states.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../../domain/lead.dart';
import '../../../../domain/lead_formated.dart';
import '../crm_list_page.dart';
import 'crm_detail_bloc.dart';
import 'crm_detail_events.dart';

class CrmDetail extends StatefulWidget {
  Lead lead;

  CrmDetail({super.key, required this.lead});

  @override
  State<CrmDetail> createState() => _CrmDetailState();
}

class _CrmDetailState extends State<CrmDetail> {
  Map<String, List<String>> fieldOptions = {
    'stage': [],
    'user': [],
    'company': [],
    'client': [],
    'tags': [],
    'team': [],
  };
  Map <String, List<String>> selectedItems = {
    'stage': [],
    'user': [],
    'company': [],
    'client': [],
    'tags': [],
    'team': [],
  };
  Map<String, dynamic> changes = {};
  late LeadFormated leadFormated;
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
  late Map<String, dynamic> initialData = {};

  bool isEditEnabled = false;
  bool isDataChanged = false;
  bool isDataLoading = true;
  int? selectedPriority;
  double currentValue = 0;


  @override
  void initState() {
    super.initState();
    configData();
  }

  void configData() {
    BlocProvider.of<CrmDetailBloc>(context).add(SetState());
    BlocProvider.of<CrmDetailBloc>(context).getLeadFormated(widget.lead).then((lead) {
      setState(() {
        leadFormated = lead;
        initialData = leadFormated.toJson();
        selectedItems['tags'] = leadFormated.tags ?? [];
        selectedItems['stage'] = [leadFormated.stage ?? ''];
        selectedItems['user'] = [leadFormated.user ?? ''];
        selectedItems['company'] = [leadFormated.company ?? ''];
        selectedItems['client'] = [leadFormated.client ?? ''];
        selectedItems['team'] = [leadFormated.team ?? ''];
      });
    }).then((_) {
      return BlocProvider.of<CrmDetailBloc>(context).getFieldsOptions();
    }).then((options) {
      setState(() {
        fieldOptions = options;
      });
    }).then((_) {
      BlocProvider.of<CrmDetailBloc>(context).add(LoadLead(widget.lead));
    });

    _setText();

    Map<String, List<int>> allIds = {
      'stage': [],
      'user': [],
      'company': [],
      'client': [],
      'tags': widget.lead.tagIds ?? [],
      'team': [],
    };
    if (widget.lead.stageId != null) {
      allIds['stage']?.add(widget.lead.stageId!);
    }
    if (widget.lead.userId != null) {
      allIds['user']?.add(widget.lead.userId!);
    }
    if (widget.lead.companyId != null) {
      allIds['company']?.add(widget.lead.companyId!);
    }
    if (widget.lead.clientId != null) {
      allIds['client']?.add(widget.lead.clientId!);
    }
    if (widget.lead.teamId != null) {
      allIds['team']?.add(widget.lead.teamId!);
    }

    currentValue = widget.lead.probability ?? 0;
  }

  Future<void> _assignDataFromString(int id, String type, TextEditingController controller) async {
    String data = await BlocProvider.of<CrmDetailBloc>(context).getDataString(id, type);
    controller.text = data;
  }

  Future<void> _assignDataFromList(List<int> ids, String type, TextEditingController controller) async {
    List<String> dataList = await BlocProvider.of<CrmDetailBloc>(context).getDataList(ids, type);
    String dataString = dataList.join(', ');
    controller.text = dataString;
  }

  Future<void> getDataStringForId() async {
    await _assignDataFromString(widget.lead.companyId ?? 0, 'res.company', _companyController);
    await _assignDataFromString(widget.lead.userId ?? 0, 'res.users', _userController);
    await _assignDataFromString(widget.lead.teamId ?? 0, 'crm.team', _teamController);
    await _assignDataFromList(widget.lead.tagIds ?? [0], 'crm.tag', _tagsController);
    await _assignDataFromString(widget.lead.stageId ?? 0, 'crm.stage', _stageController);
    await _assignDataFromString(widget.lead.clientId ?? 0, 'res.partner', _clientNameController);
    await _assignDataFromString(widget.lead.teamId ?? 0, 'crm.team', _teamController);
  }

  Future<List<String>> getLeadSelectedItems() async {
    List<int> tagIds = widget.lead.tagIds ?? [0];
    List<String> selectedItems = await BlocProvider.of<CrmDetailBloc>(context).getDataList(tagIds, 'crm.tag');
    return selectedItems;
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

  void _onFieldChanged() {
    setState(() {
      isDataChanged = true;
    });
  }

  void _onUpdatePressed() {
    changes['id'] = widget.lead.id;

    BlocProvider.of<CrmDetailBloc>(context).add(SaveLeadButtonPressed(changes));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Recargando, no haga nada"),
    ));
  }

  void _onResetPressed() {
    setState(() {
      isDataChanged = false;
      isEditEnabled = false;
    });
    configData();
  }

  void _setText() {
    _nameController = TextEditingController(text: widget.lead.name);
    _clientNameController = TextEditingController();
    _phoneController = TextEditingController(text: widget.lead.phone);
    _emailController = TextEditingController(text: widget.lead.email);
    _companyController = TextEditingController();
    _userController = TextEditingController();
    _dateDeadLineController = TextEditingController(text: widget.lead.dateDeadline);
    _teamController = TextEditingController();
    _expectedRevenueController = TextEditingController(text: widget.lead.expectedRevenue.toString());
    _tagsController = TextEditingController();
    _priorityController = TextEditingController(text: widget.lead.priority);
    _probabilityController = TextEditingController(text: widget.lead.probability.toString());
    _createDateController = TextEditingController(text: widget.lead.createDate);
    _stageController = TextEditingController();
    getDataStringForId();
  }

  @override
  Widget build(BuildContext context) {
    bool canPop = !isEditEnabled;
    return Scaffold (
      body: BlocListener<CrmDetailBloc, CrmDetailStates>(
        listener: (context, state) {
          if (state is CrmDetailSuccess) {
            setState(() {
              isDataLoading = false;
              selectedPriority = int.parse(widget.lead.priority ?? '0');
            });
          } else if (state is CrmDetailSave) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Guardado con éxito"),
            ));
            changes.clear();
          } else if (state is CrmDetailError) {
            _onResetPressed();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Error al guardar"),
            ));
            changes.clear();
          } else if (state is CrmDetailReload) {
            widget.lead = state.lead;
            _onResetPressed();

          }
        },
        child: BlocBuilder<CrmDetailBloc, CrmDetailStates>(
          builder: (context, state) {
            if (state is CrmDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return PopScope(
              canPop: canPop,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Oportunidad',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
                  ),
                  backgroundColor: Colors.purpleAccent.shade400,
                  leading: canPop ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CrmListPage()));
                    },
                  ) : null,
                  actions: [
                    if (isDataChanged)
                      IconButton(
                        onPressed: _onUpdatePressed,
                        icon: const Icon(Icons.upload),
                        tooltip: 'Guardar Cambios',
                      ),
                    IconButton(
                      onPressed: isDataChanged ? null : () {
                        setState(() {
                          isEditEnabled = !isEditEnabled;
                        });
                      },
                      icon: Icon(isEditEnabled ? Icons.edit_off : Icons.edit),
                      tooltip: isEditEnabled ? 'Deshabilitar Edición' : 'Habilitar Edición',
                    ),
                  ],
                ),
                body: _buildBody(state),
                floatingActionButton: FloatingActionButton(
                    onPressed: isDataChanged ? _onResetPressed : null,
                    backgroundColor: isDataChanged ? Colors.red : Colors.grey,
                    child: const Icon(Icons.undo)
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(CrmDetailStates state) {
    if (state is CrmDetailSuccess) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField("Nombre", _nameController, 'Text', 'name'),
            _buildField("Cliente", _clientNameController, 'Client', 'client'),
            _buildField("Teléfono", _phoneController, 'Text', 'phone'),
            _buildField("Email", _emailController, 'Text', 'email'),
            _buildField('Fecha límite', _dateDeadLineController, 'Date', 'date_deadline'),
            _buildField('Compañía', _companyController, 'Company', 'company'),
            _buildField('Usuario', _userController, 'User', 'user'),
            _buildField('Equipo', _teamController, 'Team', 'team'),
            _buildField('Ingreso esperado', _expectedRevenueController, 'Text', 'expected_revenue'),
            _buildField('Tags', _tagsController, 'Tags', 'tags'),
            _buildPriorityField('Prioridad', _priorityController, int.parse(widget.lead.priority as String)),
            _buildField('Probabilidad', _probabilityController, 'Text', 'probability'),
            _buildField('Fecha de creación', _createDateController, 'Text', 'create_date'),
            _buildField('Etapa', _stageController, 'Stage', 'stage'),
          ],
        ),
      );
    } else {
      return const LinearProgressIndicator();
    }
  }

  Widget _buildField(String label, TextEditingController controller, String caseType, String type) {
    Widget fieldWidget;

    switch (caseType) {
      case 'Text':
        fieldWidget = _buildTextField(controller, label, type);
        break;
      case 'Date':
        fieldWidget = _buildDateTextField(controller);
        break;
      case 'Tags' || 'Client' || 'Company' || 'User' || 'Stage' || 'Team':
        fieldWidget = _buildComboBoxFields(controller, caseType.toLowerCase());
        break;
      default:
        fieldWidget = _buildTextField(controller, label, type);
    }

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
        fieldWidget,
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String type) {
    bool isEnable = true;
    if (type == 'phone' || type == 'email' || type == 'create_date') {
      isEnable = false;
    }
    if (type.toLowerCase() == 'probability') {
      return _buildSlider(controller, label, type);
    }
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
        child: isEditEnabled
            ? TextField(
          enabled: isEnable,
          controller: controller,
          onChanged: (value) {
            _onFieldChanged();
            addChanges(type, value);
          },
          // Configura el tipo de entrada y el formateador según el tipo 'expected_revenue'
          keyboardType: type.toLowerCase() == 'expected_revenue' ? TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          inputFormatters: type.toLowerCase() == 'expected_revenue' ? [DecimalTextInputFormatter()] : [],
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        )
            : Text(
          controller.text,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }


  Widget _buildSlider(TextEditingController controller, String label, String type) {
    return isEditEnabled ? Slider(
      value: currentValue,
      min: 0,
      max: 100,
      divisions: 100,
      label: currentValue.round().toString(),
      onChanged: isEditEnabled ? (double value) {
        setState(() {
          currentValue = value;
          addChanges('probability', value);
          _onFieldChanged();
        });
      } : null,
    ) : Text(
      '${currentValue.round()}%',
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }

  Widget _buildDateTextField(TextEditingController controller) {
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
        child: isEditEnabled
            ? InkWell(
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
                  _onFieldChanged();
                  addChanges('date_deadline', controller.text);
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
            : Text(
          controller.text,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildComboBoxFields(TextEditingController editingController, String type) {
    List<String> list = fieldOptions[type] ?? [];
    String? selectedValue;

    if (isEditEnabled) {
      if (selectedItems[type]?.isEmpty ?? true) {
        list.add('Ninguno');
        selectedValue = 'Ninguno';
      } else {
        if (selectedItems[type]?.first != '') {
          selectedValue = selectedItems[type]?.first;
        } else {
          list.add('Ninguno');
          selectedValue = 'Ninguno';
        }
      }

      for (int i = 0; i < list.length; i++) {
        if (list.lastIndexOf(list[i]) != i) {
          list.removeAt(i);
        }
      }
    }

    if (type == 'tags') {
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
          child: isEditEnabled
              ? MultiSelectDialogField(
            items: list.map((e) => MultiSelectItem(e, e)).toList(),
            initialValue: selectedItems[type]?.map((e) => e.toString()).toList() ?? [],
            title: Text('Select $type'),
            buttonText: Text('Select $type'),
            onConfirm: (results) {
              setState(() {
                selectedItems[type] = results.map((result) => result.toString()).toList();
                _onFieldChanged();
                addChanges(type.toLowerCase(), results.map((result) => result.toString()).toList());
              });
            },
          )
              : Text(
            editingController.text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[400]!,
            width: 1.5,
          ),
        ),
        child: isEditEnabled
            ? Padding(
          padding: const EdgeInsets.all(8),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            hint: const Text('Selecciona una opción'),
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: selectedValue,
            onChanged: (String? value) {
              setState(() {
                selectedItems[type] = [value!];
                _onFieldChanged();
                addChanges(type.toLowerCase(), value);
              });
            },
            decoration: InputDecoration(
              labelText: 'Selecciona $type',
              border: const OutlineInputBorder(),
            ),
          ),
        )
            : Text(
          editingController.text,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }
  }

  Widget _buildPriorityField(String label, TextEditingController controller, int initialPriority) {
    List<Widget> stars = List.generate(
      3,
          (index) => IconButton(
        onPressed: isEditEnabled ? () {
          int newPriority = index + 1;
          setState(() {
            if (selectedPriority == newPriority) {
              selectedPriority = 0;
              controller.text = '';
            } else {
              selectedPriority = newPriority;
              controller.text = '★' * selectedPriority!;
            }
            if (selectedPriority != initialPriority) {
              _onFieldChanged();
              addChanges('priority', selectedPriority);
            }
          });
        } : null,
        icon: Icon(
          index < (selectedPriority != null ? selectedPriority! : 0) ? Icons.star : Icons.star_border,
          color: Colors.yellow,
          size: 20,
        ),
      ),
    );

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
        Row(
          children: stars,
        ),
      ],
    );
  }

  void addChanges(String key, dynamic value) {
    if (initialData[key] is List) {
      if (value is List && !listEquals(value, initialData[key])) {
        changes[key] = value;
      } else if (value is! List) {
        throw Exception("Error: se esperaba una lista para la llave $key, pero se recibió un ${value.runtimeType}");
      } else {
        changes.remove(key);
      }
    } else {
      if (value != initialData[key]) {
        changes[key] = value;
      } else {
        changes.remove(key);
        setState(() {
          isDataChanged = false;
        });
      }
    }
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r'^\d+\.?\d{0,2}$');
    if (regEx.hasMatch(newValue.text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}