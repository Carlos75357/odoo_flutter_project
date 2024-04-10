import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_detail/crm_detail_page.dart';

import '../../../widgets/crm_list_page/button_new_lead.dart';
import '../../../widgets/crm_list_page/lead_widget.dart';
import '../../../widgets/crm_list_page/menu_crm.dart';
import 'crm_list_bloc.dart';
import 'crm_list_events.dart';
import 'crm_list_states.dart';

class CrmListPage extends StatefulWidget {
  const CrmListPage({super.key});

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
        title: const Text(
          'CRM',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
        ),
        backgroundColor: Colors.purpleAccent.shade400,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: leadStatuses != null
                ? buildMenu(context, leadStatuses)
                : const Center(child: CircularProgressIndicator()),
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
            leadWidgets.clear();
            leadWidgets = _buildLeadWidgets(state);
          } else if (state is CrmListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is CrmListDetail) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CrmDetail(lead: state.lead)),
            );
          } else if (state is CrmListSort) {
            leadWidgets.clear();
            leadWidgets = _buildLeadWidgets(state);
          } else if (state is CrmNewLead) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Placeholder()),
            );
          }
        },
        child: BlocBuilder<CrmListBloc, CrmListStates>(
          builder: (context, state) {
            return Stack(
              children: [
                Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: leadWidgets,
                    ),
                  ),
                ),
                buildButton(context),
              ],
            );
          },
        ),
      ),
    );
  }
}

List<Widget> _buildLeadWidgets(CrmListStates state) {
  List<Widget> leadWidgets = [];

  for (var leadData in state.data['leads']) {
    leadWidgets.add(
      LeadItemWidget(
        lead: leadData,
      ),
    );
  }

  return leadWidgets;
}