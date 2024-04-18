import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/pages/crm_list/crm_list_bloc.dart';
import '../../ui/pages/crm_list/crm_list_events.dart';

/// [buildMenu] is a function that build the menu of the [CrmListPage]
Widget buildMenu(BuildContext context, List<String>? leadStatuses) {
  return Container(
    height: 50,
    decoration: BoxDecoration(
      color: Colors.purpleAccent.shade400,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int index = 0; index < leadStatuses!.length; index++)
          Expanded(
            child: GestureDetector(
              onTap: () {
                BlocProvider.of<CrmListBloc>(context).add(ChangeFilter(filter: leadStatuses[index]));
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.white, width: index < leadStatuses.length - 1 ? 1.0 : 0.0),
                  ),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    leadStatuses[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}