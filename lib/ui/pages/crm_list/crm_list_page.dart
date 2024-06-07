import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/theme_provider.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_create/crm_create_page.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_detail/crm_detail_page.dart';
import 'package:flutter_crm_prove/ui/pages/project_list/project_detail/pjt_detail_events.dart';
import 'package:provider/provider.dart';

import '../../../widgets/crm_list_page/button_new_lead.dart';
import '../../../widgets/crm_list_page/lead_widget.dart';
import '../../../widgets/crm_list_page/menu.dart';
import 'crm_list_bloc.dart';
import 'crm_list_events.dart';
import 'crm_list_states.dart';
/// [CrmListPage] is a statefulwidget class, build the crm list page with the list of leads
class CrmListPage extends StatefulWidget {
  const CrmListPage({super.key});

  @override
  State<CrmListPage> createState() => _CrmListPageState();
}

class _CrmListPageState extends State<CrmListPage> {
  List<Widget> leadWidgets = [];
  List<String>? leadStatuses;
  bool isDarkMode = false;

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
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: leadStatuses != null
                ? buildMenu(
                context,
                leadStatuses,
                BlocProvider.of<CrmListBloc>(context),
                    (String filter) {
                  BlocProvider.of<CrmListBloc>(context).add(ChangeFilterCrm(filter: filter));
                }
            ) : const Center(child: CircularProgressIndicator()),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<CrmListBloc>(context).add(ReloadLeads());
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ), // icon
          )
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
            FirebaseCrashlytics.instance.recordError(state, null, fatal: true);
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
              MaterialPageRoute(builder: (context) => const CrmCreatePage()),
            );
          }
        },
        child: BlocBuilder<CrmListBloc, CrmListStates>(
          builder: (context, state) {
            return Stack(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.background,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: leadWidgets,
                    ),
                  ),
                ),

                buildButton(
                    context,
                  BlocProvider.of<CrmListBloc>(context),
                  NewLeadButtonPressed()
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// [_buildLeadWidgets] is a function that builds the widget which shows a lead.
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