import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_list_events.dart';

import '../../domain/lead.dart';
import '../../ui/pages/crm_list/crm_list_bloc.dart';

class LeadItemWidget extends StatelessWidget {
  final Lead lead;

  LeadItemWidget({
    required this.lead,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = List.generate(
      3,
          (index) => Icon(
        index < int.parse(lead.priority ?? '0') ? Icons.star : Icons.star_border,
        color: Colors.yellow,
        size: 20,
      ),
    );

    return GestureDetector(
      onTap: () {
        BlocProvider.of<CrmListBloc>(context).add(LeadSelected(lead: lead));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 5.0),
        child: Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.purpleAccent,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: Text(
              lead.name ?? 'Sin nombre',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingreso esperado: ${lead.expectedRevenue?.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                Text(
                  'Cliente: ${lead.contactName ?? 'Sin contacto'}',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
                Row(children: stars),
              ],
            ),
            trailing: Icon(Icons.edit, color: Colors.white, size: 16),
          ),
        ),
      ),
    );
  }
}
