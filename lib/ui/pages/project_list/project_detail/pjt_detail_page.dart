import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_events.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_states.dart';
import 'package:provider/provider.dart';

import '../../../../domain/project/project.dart';
import '../../../../theme_provider.dart';
import '../../../../widgets/crm_list_page/menu_crm.dart';

class ProjectDetailPage extends StatefulWidget {
  late Project project;
  ProjectDetailPage({super.key, required this.project});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  List<String>? stages;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProjectDetailBloc>(context).add(LoadProject(widget.project));
    BlocProvider.of<ProjectDetailBloc>(context).fetchProjectStages().then((stages) {
      setState(() {
        this.stages = stages;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CRM',
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  // TODO ProjectEditPage(project: widget.project)
                  builder: (context) => const Placeholder(),
                ),
              );
            },
            icon: const Icon(Icons.edit, color: Colors.white,),
          ),
          IconButton(
            onPressed: () {
              BlocProvider.of<ProjectDetailBloc>(context).add(ReloadDetail(widget.project.id));
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

      body: BlocListener<ProjectDetailBloc, ProjectDetailStates>(
        listener: (context, state) {
          if (state is ProjectDetailSuccess) {

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
                  actions: [
                    const IconButton(
                      onPressed: null, // crear etiqueta,
                      icon: Icon(Icons.create_new_folder),
                      tooltip: 'Guardar Cambios',
                    ),
                    IconButton(
                      onPressed: () {
                        BlocProvider.of<ProjectDetailBloc>(context).add(ReloadDetail(widget.project.id));
                      },
                      icon: const Icon(Icons.edit),
                    ),
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
}