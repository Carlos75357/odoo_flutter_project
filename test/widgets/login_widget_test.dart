import 'package:flutter/material.dart';
import 'package:flutter_crm_prove/widgets/text_fields.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomTextField widget test', () {
    testWidgets('Test custom text field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: CustomTextField(
                controller: TextEditingController(),
                hintText: 'Password',
                icon: Icon(Icons.lock),
                isPassword: true,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      expect(find.text('Password'), findsOneWidget);
    });
  });
}
