import 'package:flutter/foundation.dart';
import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:flutter_crm_prove/data/repository/repository.dart';
import 'package:flutter_crm_prove/data/repository/repository_response.dart';
import 'package:test/test.dart';

class RespositoryTest {
}

void main() {
  group('Respository test', () {
    late Repository repository;
    late OdooClient odooClient;
    int id = 133;

    setUpAll(() async {
      odooClient = OdooClient();
      repository = Repository(odooClient: odooClient);
      await repository.login('https://demos15.aurestic.com', 'admin', 'admin');
    });

    test('Login test', () async {
      expect(odooClient.jsonRpcClient.sessionId, isNotNull);
      if (kDebugMode) {
        print(odooClient.jsonRpcClient.sessionId);
      }
    });

    test('Read Lead test', () async {
      CrmLead lead = await repository.listLead('crm.lead', id);
      expect(lead.id, id);
      if (kDebugMode) {
        print(lead.toString());
      }
    });

    test('List leads test', () async {
      List<CrmLead> leads = await repository.listLeads('crm.lead', [['expected_revenue', '>', 1000]]);
      expect(leads.length, greaterThan(0));
      if (kDebugMode) {
        for (CrmLead lead in leads) {
          print(lead.toString());
        }
      }
    });

    test('Create lead test', () async {
      CreateResponse createResponse = await repository.createLead('crm.lead', {'name': 'Prueba2', 'description': 'Prueba2', 'expected_revenue': 100000});
      expect(createResponse.success, true);
      if (kDebugMode) {
        print(createResponse.success);
      }
    });

    test('Unlink lead test', () async {
      UnlinkResponse unlinkResponse = await repository.unlinkLead('crm.lead', id);
      expect(unlinkResponse.records, true);
      if (kDebugMode) {
        print(unlinkResponse.records);
      }
    });

    test('tagName test', () async {
      List<String> tagNames = await repository.tagNames([1,2,3]);
      expect(tagNames[0], 'Product');
      expect(tagNames[1], 'Software');
      expect(tagNames[2], 'Services');

      if (kDebugMode) {
        for (int i = 0; i < tagNames.length; i++) {
          print('Tag ${i + 1}: ${tagNames[i]}');
        }
      }
    });
  });
}
