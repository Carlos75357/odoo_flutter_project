import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_list_events.dart';

import '../../domain/crm/lead.dart';
import '../../ui/pages/crm_list/crm_list_bloc.dart';

/// [LeadItemWidget] is a widget class, build the lead item widget
class LeadItemWidget extends StatelessWidget {
  final Lead lead;

  const LeadItemWidget({super.key,
    required this.lead,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = List.generate(
      3,
          (index) => Icon(
        index < int.parse((lead.priority ?? 0) as String) ? Icons.star : Icons.star_border,
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
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                offset: Offset(0, 5),
              )
            ]
          ),
          child: ListTile(
            title: Text(
              lead.name ?? 'Sin nombre',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingreso esperado: ${lead.expectedRevenue?.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                Text(
                  'Cliente: ${lead.clientId ?? 'Sin contacto'}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                Row(children: stars),
              ],
            ),
            trailing: const Icon(Icons.edit, color: Colors.white, size: 16),
          ),
        ),
      ),
    );
  }
}
