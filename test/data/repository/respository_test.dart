import 'package:flutter/foundation.dart';
import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:flutter_crm_prove/data/repository/repository.dart';
import 'package:flutter_crm_prove/data/repository/repository_response.dart';
import 'package:flutter_crm_prove/domain/lead.dart';
import 'package:test/test.dart';

class RespositoryTest {
}

void main() {
  group('Respository test', () {
    late Repository repository;
    late OdooClient odooClient;
    int id = 172; //157

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
    //
    // test('Read Lead test', () async {
    //   Lead lead = await repository.listLead('crm.lead', id);
    //   expect(lead.id, id);
    //   if (kDebugMode) {
    //     print(lead.toString());
    //   }
    // });
    //
    // test('List leads test', () async {
    //   List<Lead> leads = await repository.listLeads('crm.lead', [['expected_revenue', '>', 1000]]);
    //   expect(leads.length, greaterThan(0));
    //   if (kDebugMode) {
    //     for (Lead lead in leads) {
    //       print(lead.toString());
    //     }
    //   }
    // });
    //
    //
    // test('Create lead test', () async {
    //   // CreateResponse createResponse = await repository.createLead('crm.lead', {'name': 'Prueba2', 'description': 'Prueba2', 'expected_revenue': 100000});
    //   CreateResponse createResponse = await repository.createLead('crm.lead', {
    //     'name': 'Prueba2',
    //     'description': 'Prueba2',
    //     'contact_name': 'Nombre de contacto',
    //     'phone': '+123456789',
    //     'email_from': 'correo@example.com',
    //     'company_id': 1,
    //     'user_id': 2,
    //     'date_deadline': '2024-12-31',
    //     'team_id': 1,
    //     'expected_revenue': 100000,
    //     'tag_ids': [1, 2, 3],
    //     'priority': '1',
    //     'probability': '0.75',
    //     'create_date': '2024-03-25',
    //     'stage_id': 1,
    //   });
    //
    //   expect(createResponse.success, true);
    //   if (kDebugMode) {
    //     print(createResponse.success);
    //   }
    // });
    //
    // test('Unlink lead test', () async {
    //   UnlinkResponse unlinkResponse = await repository.unlinkLead('crm.lead', id);
    //   expect(unlinkResponse.records, true);
    //   if (kDebugMode) {
    //     print(unlinkResponse.records);
    //   }
    // });

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

    test('stageNameById test', () async {
      String stageNames = await repository.stageNameById(2);
      expect(stageNames, 'Qualified');

      if (kDebugMode) {
        print('Stage 2: $stageNames');
      }
    });

    test('stageIdByName test', () async {
      int stageId = await repository.stageIdByName('Propuesta');
      if (kDebugMode) {
        print('Stage $stageId: $stageId');
      }
      expect(stageId, 3);
    });

    test('stageName test', () async {
      List<String> stageNames = await repository.stageNames();
      expect(stageNames[0], 'Nuevo');
      expect(stageNames[1], 'Calificado');
      expect(stageNames[2], 'Propuesta');
      expect(stageNames[3], 'Ganado');
      if (kDebugMode) {
        for (int i = 0; i < stageNames.length; i++) {
          print('Stage ${i + 1}: ${stageNames[i]}');
        }
      }
    });
  });
}
