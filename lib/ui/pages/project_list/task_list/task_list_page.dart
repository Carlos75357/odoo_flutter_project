import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_create/task_create_page.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_list_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_list_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/task_list/task_list_states.dart';
import 'package:provider/provider.dart';

import '../../../../theme_provider.dart';
import '../../../../widgets/crm_list_page/button_new_lead.dart';
import '../../../../widgets/crm_list_page/menu.dart';
import '../../../../widgets/project_list/project_detail/task_widget.dart';

class TaskListPage extends StatefulWidget {
  final String? projectName;
  const TaskListPage({super.key, this.projectName});

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<String>? taskStages;
  List<Widget> taskWidgets = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TaskListBloc>(context).add(TaskListLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tareas de ${widget.projectName ?? 'Sin nombre'}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: taskStages != null
                ? buildMenu(context, taskStages, BlocProvider.of<TaskListBloc>(context),
                (String filter) {
                  BlocProvider.of<TaskListBloc>(context).add(ChangeFilterTask(filter));
                }
            ) : const Center(child: CircularProgressIndicator()),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<TaskListBloc>(context).add(TaskListReloadEvent());
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ), // icon
          )
        ],
      ),
      body: BlocListener<TaskListBloc, TaskListStates>(
        listener: (context, state) {
          if (state is TaskListSuccess) {
            taskWidgets.clear();
            taskWidgets = _buildTaskWidgets(state);
          } else if (state is TaskListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
            FirebaseCrashlytics.instance.recordError(state, null, fatal: true);
          } else if (state is TaskListDetail) {
            Navigator.push(
              context,
              // TaskDetailPage(task: state.task)
              MaterialPageRoute(builder: (context) => const Placeholder()),
            );
          } else if (state is TaskListReload) {
            BlocProvider.of<TaskListBloc>(context).add(TaskListReloadEvent());
          } else if (state is TaskListNew) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaskCreatePage())
            );
          } else if (state is TaskListSort) {
            taskWidgets.clear();
            taskWidgets = _buildTaskWidgets(state);
          }
        },
        child: BlocBuilder<TaskListBloc, TaskListStates>(
          builder: (context, state) {
            if (state is TaskListLoading) {
              return Stack(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.primary,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: taskWidgets,
                      ),
                    ),
                  ),
                  buildButton(
                      context,
                    BlocProvider.of<TaskListBloc>(context),
                    TaskListNewButtonPressed()
                  ),
                ],
              );
            } else if (state is TaskListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: LinearProgressIndicator());
            }
          },
        )
      )
    );
  }
}

List<Widget> _buildTaskWidgets(TaskListStates state) {
  List<Widget> taskWidgets = [];

  for (var taskData in state.data) {
    taskWidgets.add(
      TaskWidget(
        task: taskData,
      ),
    );
  }

  return taskWidgets;
}