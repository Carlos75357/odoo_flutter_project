import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/login/select_module/select_module_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/login/select_module/select_module_events.dart';
import 'package:flutter_crm_prove/ui/pages/login/select_module/select_module_states.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/pjt_list_page.dart';

import '../../crm_list/crm_list_page.dart';

class ModulePage extends StatefulWidget {
  const ModulePage({super.key});

  @override
  _ModulePageState createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.all(16.0),
      child: BlocListener<ModuleBloc, ModuleState>(
        listener: (context, state) {
          if (state is ModuleStateSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                // TODO: CANBIAR EL PLACEHOLDER
                builder: (context) => state.id == 1 ? const CrmListPage() : const ProjectListPage(),
              ),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildModuleButton(1),
                    const SizedBox(height: 20),
                    _buildModuleButton(0)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildModuleButton(int id) {
    return SizedBox(
      width: 150,
      height: 150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor, backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )
        ),
        onPressed: () {
          BlocProvider.of<ModuleBloc>(context).add(ModuleEventButtonPressed(id));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(id == 1 ? Icons.handshake : Icons.folder, size: 100, color: Colors.white,),
            Text(id == 1 ? 'CRM' : 'Proyectos', style: const TextStyle(fontSize: 20, color: Colors.white)),
          ],
        ),
      )
    );
  }
}