import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_crm_prove/domain/crm/lead.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_list_bloc.dart';
import 'package:flutter_crm_prove/ui/pages/crm_list/crm_list_events.dart';
import 'package:flutter_crm_prove/widgets/crm_list_page/button_new_lead.dart';
import 'package:flutter_crm_prove/widgets/crm_list_page/lead_widget.dart';
import 'package:flutter_crm_prove/widgets/crm_list_page/menu.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Crm widget test', () {
    testWidgets('Test buildButton widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                Builder(
                  builder: (BuildContext context) {
                    return                 buildButton(
                        context,
                        BlocProvider.of<CrmListBloc>(context),
                        NewLeadButtonPressed()
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Test LeadItemWidget widget', (WidgetTester tester) async {
      final lead = Lead(
        id: 1,
        name: 'Lead Name',
        expectedRevenue: 1000,
        clientId: 2,
        priority: '2',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return LeadItemWidget(lead: lead);
              },
            ),
          ),
        ),
      );

      expect(find.text('Lead Name'), findsOneWidget);
      expect(find.text('Ingreso esperado: 1000.00'), findsOneWidget);
      expect(find.text('Cliente: John Doe'), findsOneWidget);
    });

    testWidgets('Test buildMenu widget', (WidgetTester tester) async {
      final leadStatuses = ['Status 1', 'Status 2', 'Status 3'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return buildMenu(context, leadStatuses, BlocProvider.of<CrmListBloc>(context), ChangeFilter(filter: 'Status 1'));
              },
            ),
          ),
        ),
      );

      expect(find.text('Status 1'), findsOneWidget);
      expect(find.text('Status 2'), findsOneWidget);
      expect(find.text('Status 3'), findsOneWidget);
    });
  });
}
