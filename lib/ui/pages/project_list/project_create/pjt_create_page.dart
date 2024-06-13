import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/domain/crm/lead.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_create/pjt_create_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_create/pjt_create_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_create/pjt_create_states.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../pjt_list_page.dart';

class ProjectCreatePage extends StatefulWidget {
  const ProjectCreatePage({super.key});

  @override
  ProjectCreatePageState createState() => ProjectCreatePageState();
}

class ProjectCreatePageState extends State<ProjectCreatePage> {
  late TextEditingController _nameController;
  late TextEditingController _stagesController;

  Map<String, dynamic> changes = {
  };

  Map<String, List<String>> fieldOptions = {
    'stages': [],
    'user': [],
    'company': [],
    'client': [],
    'tags': [],
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _stagesController = TextEditingController();
    configData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _stagesController.dispose();
    super.dispose();
  }

  Future<void> configData() async {
    BlocProvider.of<ProjectCreateBloc>(context).add(SetLoadingState());

    BlocProvider.of<ProjectCreateBloc>(context).getFieldsOptions().then((options) {
      if (mounted) {
        setState(() {
          fieldOptions = options;
        });
      }
    }).then((_) {
      if (mounted) {
        BlocProvider.of<ProjectCreateBloc>(context).add(SetSuccessState());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nuevo Proyecto'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: BlocListener<ProjectCreateBloc, ProjectCreateStates>(
        listener: (context, state) {
          if (state is ProjectCreateDone) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Guardado con exito"),
            ));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProjectListPage()));
          }
          if (state is ProjectCreateError) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Error al guardar"),
            ));
            FirebaseCrashlytics.instance.recordError(state, null, fatal: true);
          }
        },
        child: BlocBuilder<ProjectCreateBloc, ProjectCreateStates>(
          builder: (context, state) {
            if (state is ProjectCreateLoading) {
              return const LinearProgressIndicator();
            }
            if (state is ProjectCreateSuccess) {
              return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildField('Nombre del proyecto', _nameController, 'Text', 'name'),
                        _buildField('Stages', _stagesController, 'Stage', 'stages'),
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
      case 'Stage':
        fieldWidget = _buildDropDownField(controller, type.toLowerCase());
        break;
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

  /// [_buildDropDownField] method to create the dropdown field.
  Widget _buildDropDownField(TextEditingController controller, String type) {
    List<String> list = fieldOptions[type] ?? [];
    // print('Lista: ${list.length}');
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
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
  }

  Widget _buildButton() {
    return ElevatedButton(

      onPressed: () {
        updateChangesIfNotEmpty('name', _nameController.text);
        updateChangesIfNotEmpty('stages', _stagesController.text);

        if (_stagesController.text.isNotEmpty) {
          changes['stages'] = _stagesController.text.split(',').map((stage) => stage.trim()).toList();
        }


        BlocProvider.of<ProjectCreateBloc>(context).add(CreateEvents(values: changes));
      },
      child: const Text('Crear Proyecto'),
    );
  }

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
