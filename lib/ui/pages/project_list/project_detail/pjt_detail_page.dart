import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_states.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/project_edit/pjt_edit_page.dart';

import '../../../../domain/project/project.dart';
import '../../../../domain/Task/task.dart';
import '../../../../widgets/crm_list_page/button_new_lead.dart';
import '../../../../widgets/crm_list_page/menu_crm.dart';
import '../../../../widgets/project_list/project_detail/task_widget.dart';

class ProjectDetailPage extends StatefulWidget {
  late Project project;
  ProjectDetailPage({super.key, required this.project});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  List<String>? stages;
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    configData();
  }

  void configData() async {
    BlocProvider.of<ProjectDetailBloc>(context).add(SetState());
    BlocProvider.of<ProjectDetailBloc>(context).fetchProjectTaskStages().then((stages) {
      setState(() {
        this.stages = stages;
      });
    }).then((_) {
      BlocProvider.of<ProjectDetailBloc>(context).add(LoadProject(widget.project));
    });
  }

  void _onProjectSave(Project updateProject) {
    setState(() {
      widget.project = updateProject;
    });
    BlocProvider.of<ProjectDetailBloc>(context).add(ReloadDetail(updateProject.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: BlocListener<ProjectDetailBloc, ProjectDetailStates>(
        listener: (context, state) {
          if (state is ProjectDetailSuccess) {
            BlocProvider.of<ProjectDetailBloc>(context).tasks().then((tasks) {
              setState(() {
                this.tasks = tasks;
              });
            });
          } else if (state is ProjectReloaded) {
            widget.project = state.project;
          }
        },
        child: BlocBuilder<ProjectDetailBloc, ProjectDetailStates> (
          builder: (context, state) {
            if (state is ProjectDetailSuccess) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Proyecto',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(60.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: stages != null
                          ? buildMenu(context, stages)
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<ProjectDetailBloc>(context).add(ReloadDetail(widget.project.id));
                      },
                      icon: const Icon(Icons.refresh, color: Colors.white,),
                    ),
                    IconButton(
                      onPressed: () {
                        _showEditDialog(widget.project.name ?? "");
                      },
                      icon: const Icon(Icons.edit, color: Colors.white,),
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => const Placeholder()),
                    //     );
                    //   }, // crear etiqueta,
                    //   icon: const Icon(Icons.create_new_folder, color: Colors.white,),
                    //   tooltip: 'Crear nueva tarea',
                    // )
                  ],
                ),
                body: Stack(
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.background,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildTaskWidget(),
                        ),
                      ),
                    ),
                    buildButton(
                        context,
                        BlocProvider.of<ProjectDetailBloc>(context),
                        NewProjectButtonPressed()
                    )
                  ],
                ),
              );
            } else if (state is ProjectDetailError) {
              return const Center(child: Text("Error al cargar el proyecto"));
            }  else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  void _showEditDialog(String projectName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditPopupPage(
          project: widget.project,
          onSave: _onProjectSave,
        );
      },
    );
  }

  List<Widget> _buildTaskWidget() {
    List<Widget> taskWidgets = [];

    for (var taskData in tasks) {
      taskWidgets.add(
        TaskWidget(
          task: taskData,
        ),
      );
    }

    return taskWidgets;
  }
}