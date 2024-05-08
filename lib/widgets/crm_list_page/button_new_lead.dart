import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/remote_config_service.dart';

import '../../ui/pages/crm_list/crm_list_bloc.dart';
import '../../ui/pages/crm_list/crm_list_events.dart';

/// [buildButton] method to create the button.
Widget buildButton(BuildContext context) {
  if (RemoteConfigService.instance.canCreateCrmLeads) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<CrmListBloc>(context).add(NewLeadButtonPressed());
        },
        child: const Icon(Icons.add),
      ),
    );
  } else {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        onPressed: () {
          // FirebaseCrashlytics.instance.recordError("Error al crear una nueva oportunidad", null, fatal: true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No tienes permisos para crear nuevas oportunidades"),
            )
          );
        },
        child: const Icon(Icons.block),
      ),
    );
  }
}