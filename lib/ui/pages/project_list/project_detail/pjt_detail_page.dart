import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_states.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/project_edit/pjt_edit_page.dart';

import '../../../../domain/Task/task_formated.dart';
import '../../../../domain/project/project.dart';
import '../../../../domain/Task/task.dart';
import '../../../../widgets/crm_list_page/button_new_lead.dart';
import '../../../../widgets/crm_list_page/menu.dart';
import '../../../../widgets/project_list/project_detail/task_widget.dart';
import '../task_list/task_create/task_create_page.dart';
import '../task_list/task_detail/task_detail_page.dart';

class ProjectDetailPage extends StatefulWidget {
  Project project;
  ProjectDetailPage({super.key, required this.project});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  List<String>? stages;
  List<Task> tasks = [];
  List<TaskFormated> taskFormatedList = [];
  List<Widget> taskWidgets = [];

  @override
  void initState() {
    super.initState();
    configData();
  }

  void configData() async {
    BlocProvider.of<ProjectDetailBloc>(context).add(SetState());
    BlocProvider.of<ProjectDetailBloc>(context).add(LoadProject(widget.project));
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
            taskWidgets.clear();
            taskWidgets = _buildTaskWidget();
          } else if (state is TaskNew) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TaskCreatePage(projectName: widget.project.name ?? 'Sin nombre', project: widget.project),
              ),
            );
          } else if (state is TaskDetail) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailPage(task: state.task, project: widget.project),
              )
            );
          } else if (state is ProjectReloaded) {
            widget.project = state.project;
            configData();
            taskWidgets.clear();
            taskWidgets = _buildTaskWidget();
          } else if (state is ProjectDetailLoaded) {
            BlocProvider.of<ProjectDetailBloc>(context).fetchProjectTaskStages().then((stages) {
              setState(() {
                this.stages = stages;
              });
            }).then((_) {
              BlocProvider.of<ProjectDetailBloc>(context).tasks().then((tasks) {
                setState(() {
                  this.tasks = tasks;
                });
              }).then((_) {
                BlocProvider.of<ProjectDetailBloc>(context).getTaskFormated(tasks).then((taskFormatedList) {
                  setState(() {
                    this.taskFormatedList = taskFormatedList;
                  });
                }).then((_) {
                  BlocProvider.of<ProjectDetailBloc>(context).add(SetSuccessState());
                });
              });
            });
          } else if ( state is ProjectDetailSort) {
            taskWidgets.clear();
            taskFormatedList.clear();
            BlocProvider.of<ProjectDetailBloc>(context).getTaskFormated(state.data['tasks']).then((taskFormatedList) {
              setState(() {
                this.taskFormatedList = taskFormatedList;
              });
            }).then((_) {
              taskWidgets = _buildTaskWidget();
              BlocProvider.of<ProjectDetailBloc>(context).add(SetSuccessState());
            });
          }
        },
        child: BlocBuilder<ProjectDetailBloc, ProjectDetailStates> (
          builder: (context, state) {
            if (state is ProjectDetailSuccess) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Tareas de ${widget.project.name ?? 'Sin nombre'}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(60.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: stages != null
                          ? buildMenu(
                          context,
                          stages,
                          BlocProvider.of<ProjectDetailBloc>(context),
                              (String filter) {
                            BlocProvider.of<ProjectDetailBloc>(context).add(ChangeFilter(filter));
                          }
                      ) : const Center(child: CircularProgressIndicator()),
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
                  ],
                ),
                body: Stack(
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.background,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: taskWidgets,
                        ),
                      ),
                    ),
                    buildButton(
                        context,
                        BlocProvider.of<ProjectDetailBloc>(context),
                        NewTaskButtonPressed()
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

    for (var taskData in taskFormatedList) {
      taskWidgets.add(
        TaskWidget(
          task: taskData,
        ),
      );
    }

    return taskWidgets;
  }
}