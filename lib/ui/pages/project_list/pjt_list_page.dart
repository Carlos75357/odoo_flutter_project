import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/pjt_list_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/pjt_list_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/pjt_list_states.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_page.dart';
import 'package:flutter_crm_prove/widgets/crm_list_page/button_new_lead.dart';
import 'package:provider/provider.dart';

import '../../../domain/project/project.dart';
import '../../../domain/project/project_formated.dart';
import '../../../theme_provider.dart';
import '../../../widgets/project_list/project_widget.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  List<Project> projects = [];
  List<ProjectFormated> projectsFormated = [];


  @override
  void initState() {
    super.initState();
    BlocProvider.of<PjtListBloc>(context).add(LoadAll());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Project List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<PjtListBloc>(context).add(ReloadAll());
            },
            icon: const Icon(Icons.refresh, color: Colors.white,),
          ),
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: BlocListener<PjtListBloc, PjtListStates>(
        listener: (context, state) {
          if (state is PjtListSuccess) {
            setState(() {
              projectsFormated = state.data['projects_formated'];
            });
          } else if (state is PjtNew) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Placeholder(),
              ),
            );
          } else if (state is PjtDetail) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectDetailPage(project: state.project),
              ),
            );
          }
        },
        child: BlocBuilder<PjtListBloc, PjtListStates>(
          builder: (context, state) {
            if (state is PjtListLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PjtListSuccess) {
              return Stack(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.background,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildProjectWidget(),
                      ),
                    ),
                  ),
                  buildButton(
                      context,
                    BlocProvider.of<PjtListBloc>(context),
                    PjtNew()
                  )
                ],
              );
            } else {
              return const LinearProgressIndicator();
            }
          },
        ),
      )
    );
  }

  List<Widget> _buildProjectWidget() {
    List<Widget> projectWidgets = [];

    for (var projectData in projectsFormated) {
      projectWidgets.add(
        ProjectWidget(
          projectFormated: projectData,
        ),
      );
    }

    return projectWidgets;
  }
}