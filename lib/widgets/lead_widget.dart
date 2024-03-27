import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_list_events.dart';

import '../ui/pages/crm_list/crm_list_bloc.dart';

class LeadItemWidget extends StatelessWidget {
  final int leadId;
  final String opportunityName;
  final int expectedRevenue;
  final String customerName;
  final String priority;

  LeadItemWidget({
    required this.leadId,
    required this.opportunityName,
    required this.expectedRevenue,
    required this.customerName,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = List.generate(
      3,
          (index) => Icon(
        index < int.parse(priority) ? Icons.star : Icons.star_border,
        color: Colors.yellow,
        size: 20,
      ),
    );

    return GestureDetector(
      onTap: () {
        print('Lead selected: $leadId');
        BlocProvider.of<CrmListBloc>(context).add(LeadSelected(leadId: leadId));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 10.0, 5.0),
        child: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            color: Colors.purpleAccent,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizedBox(
            height: 100.0,
            child: ListTile(
              title: Text(
                opportunityName,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ingreso esperado: ${expectedRevenue.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  Text(
                    'Cliente: $customerName',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  Row(children: stars),
                ],
              ),
              trailing: Icon(Icons.edit, color: Colors.white, size: 16),
            ),
          ),
        ),
      ),
    );
  }
}
