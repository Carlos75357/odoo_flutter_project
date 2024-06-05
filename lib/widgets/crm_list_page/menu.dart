import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/pages/crm_list/crm_list_bloc.dart';
import '../../ui/pages/crm_list/crm_list_events.dart';

/// [buildMenu] is a function that builds the menu of the [CrmListPage]
Widget buildMenu(BuildContext context, List<String>? statuses, Bloc bloc, dynamic event) {
  final screenWidth = MediaQuery.of(context).size.width;
  const minItemWidth = 70.0;
  const defaultItemWidth = 120.0;
  double itemWidth = screenWidth / statuses!.length;

  if (itemWidth < minItemWidth) {
    itemWidth = defaultItemWidth;
  }

  return Container(
    height: 50,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(10),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int index = 0; index < statuses.length; index++)
            SizedBox(
              width: itemWidth,
              child: GestureDetector(
                onTap: () {
                  bloc.add(event);
                  // BlocProvider.of<bloc>(context).add(ChangeFilter(filter: statuses[index]));
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.white, width: index < statuses.length - 1 ? 1.0 : 0.0),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      statuses[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}