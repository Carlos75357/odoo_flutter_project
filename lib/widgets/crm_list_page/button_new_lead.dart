import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/pages/crm_list/crm_list_bloc.dart';
import '../../ui/pages/crm_list/crm_list_events.dart';

/// [buildButton] method to create the button.
Widget buildButton(BuildContext context) {
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
}