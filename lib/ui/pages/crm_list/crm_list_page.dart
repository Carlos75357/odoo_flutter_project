import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_detail/crm_detail.dart';

import '../../../widgets/lead_widget.dart';
import 'crm_list_bloc.dart';
import 'crm_list_events.dart';
import 'crm_list_states.dart';

class CrmListPage extends StatefulWidget {
  const CrmListPage({Key? key}) : super(key: key);

  @override
  State<CrmListPage> createState() => _CrmListPageState();
}

class _CrmListPageState extends State<CrmListPage> {
  List<Widget> leadWidgets = [];
  List<String>? leadStatuses;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CrmListBloc>(context).add(LoadAllLeads());
    BlocProvider.of<CrmListBloc>(context).fetchLeadStatuses().then((statuses) {
      setState(() {
        leadStatuses = statuses;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
        backgroundColor: Colors.purpleAccent.shade400,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              child: leadStatuses != null
                  ? Container(
                decoration: BoxDecoration(
                  color: Colors.purpleAccent.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: <Widget>[
                    for (int index = 0; index < leadStatuses!.length; index++)
                      GestureDetector(
                        onTap: () {
                          // Emitir la señal para ordenar aquí, utilizando el índice o el valor correspondiente
                          // Ejemplo: emit(SortByStatus(leadStatus: leadStatuses![index]));
                          BlocProvider.of<CrmListBloc>(context).add(ChangeFilter(filter: leadStatuses![index]));
                        },
                        child: Expanded(
                          child: Center(
                            child: Text(
                              leadStatuses![index],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    for (int i = 0; i < leadStatuses!.length - 1; i++)
                      Container(
                        width: 1,
                        color: Colors.white,
                        height: 20,
                      )
                  ],
                ),

              )
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<CrmListBloc>(context).add(ReloadLeads());
            },
            icon: const Icon(Icons.update, color: Colors.white),
          ),
        ],
      ),
      body: BlocListener<CrmListBloc, CrmListStates>(
        listener: (context, state) {
          if (state is CrmListSuccess) {
            leadWidgets = _buildLeadWidgets(state);
          } else if (state is CrmListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is CrmListDetail) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CrmDetail(leadId: state.id)),
            );

          }
        },
        child: BlocBuilder<CrmListBloc, CrmListStates>(
          builder: (context, state) {
            return Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: leadWidgets,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

List<Widget> _buildLeadWidgets(CrmListSuccess state) {
  List<Widget> leadWidgets = [];

  for (var leadData in state.data['leads']) {
    leadWidgets.add(
      LeadItemWidget(
        leadId: leadData.id,
        opportunityName: leadData.name ?? 'N/A',
        expectedRevenue: leadData.expectedRevenue ?? 0.0,
        customerName: leadData.contactName ?? 'N/A',
        priority: leadData.priority ?? 0.0,
      ),
    );
  }

  return leadWidgets;
}
