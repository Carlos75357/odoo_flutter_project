import 'package:flutter/foundation.dart';
import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:test/test.dart';

class OdooClientTest {
}
void main() async {
  group('Odoo client test', () {
    late OdooClient odooClient;
    int id = 127;

    setUpAll(() async {
      odooClient = OdooClient();
      await odooClient.authenticate('https://demos15.aurestic.com', 'admin', 'admin');
    });

    test('Authenticate test', () async {
      expect(odooClient.jsonRpcClient.sessionId, isNotNull);
    });

    test('SearchRead test', () async {
      List<Map<String, dynamic>> leads = await odooClient.searchRead('crm.lead', [['expected_revenue', '>', 1000]]);
      expect(leads.length, greaterThan(0));
      for (var lead in leads) {
        if (kDebugMode) {
          print(lead.toString());
        }
      }
    });

    test('Read test', () async {
      Map<String, dynamic> lead = await odooClient.read('crm.lead', id);
      expect(lead, isNotNull);
      if (kDebugMode) {
        print(lead);
      }
    });
    //
    // test('Create test', () async {
    //   Map<String, dynamic> createResponse = await odooClient.create('crm.lead', {'name': 'Prueba2', 'description': 'Prueba2', 'expected_revenue': 100000});
    //   expect(createResponse['result'], isNotNull);
    //   expect(createResponse['result'], greaterThan(0));
    //   // expect(createResponse.success, isTrue);
    //   // expect(createResponse.id, isNotNull);
    //   // expect(createResponse.id, greaterThan(0));
    //   if (kDebugMode) {
    //     print(createResponse['result']);
    //   }
    // });
    //
    // test('Write test', () async {
    //   Lead lead = Lead(id: id, name: 'sobreescrito');
    //   bool writeResponse = await odooClient.write('crm.lead', id, lead);
    //
    //   expect(writeResponse, isTrue);
    //   expect(writeResponse, isNotNull);
    //   Map<String, dynamic> updatedCrmLead = await odooClient.read('crm.lead', id);
    //   expect(updatedCrmLead['name'], 'sobreescrito');
    //
    //   if (kDebugMode) {
    //     print('La operación de escritura fue exitosa: $writeResponse');
    //     if (writeResponse) {
    //       print('ID del registro actualizado: $writeResponse');
    //     }
    //   }
    // });
    //
    // test('Unlink test', () async {
    //   bool unlinkResponse = await odooClient.unlink('crm.lead', id);
    //   if (kDebugMode) {
    //     print(unlinkResponse);
    //   }
    // });

  });
}
