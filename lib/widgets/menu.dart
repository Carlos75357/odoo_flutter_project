import 'package:flutter/material.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_list_bloc.dart';

class Menu {
  static Future<List<String>> fetchLeadStatuses() async {
    CrmListBloc crmListBloc = CrmListBloc();
    return crmListBloc.fetchLeadStatuses();
  }

  static Widget buildFilterMenu(List<String> leadStatuses, Function(String) onFilterSelected) {
    return PopupMenuButton<String>(
      onSelected: (selectedStatus) {
        onFilterSelected(selectedStatus);
      },
      itemBuilder: (context) {
        return leadStatuses.map((status) {
          return PopupMenuItem<String>(
            value: status,
            child: Text(status),
          );
        }).toList();
      },
    );
  }
}
