import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/remote_config_service.dart';

import '../../ui/pages/crm_list/crm_list_bloc.dart';
import '../../ui/pages/crm_list/crm_list_events.dart';

/// [buildButton] method to create the button.
Widget buildButton(BuildContext context, Bloc bloc, dynamic event) {
  // return RemoteConfigService.instance.canCreateCrmLeads ? _buildNewLeadButton(context, bloc, event) : _buildErrorNewLeadButton(context);
  return _buildNewLeadButton(context, bloc, event);
}

Widget _buildNewLeadButton(BuildContext context, Bloc bloc, dynamic event) {
  return Positioned(
    bottom: 20,
    right: 20,
    child: FloatingActionButton(
      backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      onPressed: () {
        bloc.add(event);
      },
      child: const Icon(Icons.add),
    ),
  );
}

Widget _buildErrorNewLeadButton(BuildContext context) {
  return Positioned(
    bottom: 20,
    right: 20,
    child: FloatingActionButton(
      backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No tienes permisos para crear uno nuevo"),
          )
        );
      },
      child: const Icon(Icons.block),
    ),
  );
}