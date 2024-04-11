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
    int id = 177; //174

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
      Lead lead = await repository.listLead('crm.lead', id);
      expect(lead.id, id);
      if (kDebugMode) {
        print(lead.toString());
      }
    });

    test('List leads test', () async {
      List<Lead> leads = await repository.listLeads('crm.lead', [['expected_revenue', '>', 1000]]);
      expect(leads.length, greaterThan(0));
      if (kDebugMode) {
        for (Lead lead in leads) {
          print(lead.toString());
        }
      }
    });


    // test('Create lead test', () async {
    //   // CreateResponse createResponse = await repository.createLead('crm.lead', {'name': 'Prueba2', 'description': 'Prueba2', 'expected_revenue': 100000});
    //   CreateResponse createResponse = await repository.createLead('crm.lead', {
    //     'name': 'PruebaParaProbarEditar',
    //     'description': 'Prueba2',
    //     'partner_id': 1,
    //     'phone': '+123456789',
    //     'email_from': 'correo@example.com',
    //     'company_id': 1,
    //     'user_id': 2,
    //     'date_deadline': '2024-12-31',
    //     'team_id': 1,
    //     'expected_revenue': 100000,
    //     'tag_ids': [1, 2, 3],
    //     'priority': '1',
    //     'probability': 90,
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
    //
    test('Update lead test', () async {
      Lead lead = Lead(id: id, name: 'EDITADODENUEVo', stageId: 2, priority: '3', expectedRevenue: 65359, tagIds: [1], probability: 95);
      WriteResponse updateResponse = await repository.updateLead('crm.lead', id, lead);
      expect(updateResponse.success, true);
      if (kDebugMode) {
        print(updateResponse.success);
      }
    });

    test('tagName test', () async {
      List<String> tagNames = await repository.getNamesByIds('crm.tag', [1,2,3,4,5,6,7,8]);
      expect(tagNames[0], 'Product');
      expect(tagNames[1], 'Software');
      expect(tagNames[2], 'Services');
      expect(tagNames[3], 'Information');
      expect(tagNames[4], 'Design');
      expect(tagNames[5], 'Training');
      expect(tagNames[6], 'Consulting');
      expect(tagNames[7], 'Other');

      if (kDebugMode) {
        for (int i = 0; i < tagNames.length; i++) {
          print('Tag ${i + 1}: ${tagNames[i]}');
        }
      }
    });

    test('stageNameById test', () async {
      String stageNames = await repository.getNameById('crm.stage',2);
      expect(stageNames, 'Qualified');
      String clientName = await repository.getNameById('res.partner',46);
      expect(clientName, 'Henry Jordan');

      if (kDebugMode) {
        print('Stage 2: $clientName');
      }
    });

    test('stageIdByName test', () async {
      int stageId = await repository.getIdByName('crm.stage','Propuesta');
      if (kDebugMode) {
        print('Stage $stageId: $stageId');
      }
      int tagId = await repository.getIdByName('crm.tag','Producto');
      if (kDebugMode) {
        print('Tag $tagId: $tagId');
      }
      int idPartner = await repository.getIdByName('res.partner','Henry Jordan');
      if (kDebugMode) {
        print('Partner $idPartner: $idPartner');
      }
      expect(stageId, 3);
    });

    test('stageName test', () async {
      List<String> stageNames = (await repository.getAllNames('crm.stage')).cast<String>();
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

    test('get clients test', () async {
      // List<String> clients = (await repository.getAll('res.partner')).cast<String>();
      //
      // if (kDebugMode) {
      //   print('Clients: $clients');
      // }
      //
      // List<String> y = (await repository.getAll('res.users')).cast<String>();
      //
      // if (kDebugMode) {
      //   print('Users: $y');
      // }
      //
      // List<String> x = (await repository.getAll('res.company')).cast<String>();
      //
      // if (kDebugMode) {
      //   print('Companies: $x');
      // }
      //
      // List<String> z = (await repository.getAll('crm.tag')).cast<String>();
      //
      // if (kDebugMode) {
      //   print('Tags: $z');
      // }
      //
      // List<String> w = (await repository.getAll('crm.stage')).cast<String>();
      //
      // if (kDebugMode) {
      //   print('Stages: $w');
      // }
      //
      // String a = await repository.getNameById('res.users', 8);
      //
      // if (kDebugMode) {
      //   print('User: $a');
      // }
      //
      // List<dynamic> ids = await repository.getAllForModel('res.users', ['id', 'name']);
      //
      // if (kDebugMode) {
      //   print('Ids: $ids');
      // }

      List<Map<String, dynamic>> idss = await repository.getAllForModel('crm.team', ['id', 'name']);

      if (kDebugMode) {
        for (var team in idss) {
          print('Id ${team['name']}, ${team['id']}');
        }
      }
    });
  });
}
