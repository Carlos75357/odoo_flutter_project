import 'package:flutter/foundation.dart';
import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:flutter_crm_prove/data/repository/crm/crm_repository.dart';
import 'package:flutter_crm_prove/data/repository/crm/crm_repository_response.dart';
import 'package:flutter_crm_prove/data/repository/project/pjt_repository.dart';
import 'package:flutter_crm_prove/domain/crm/lead.dart';
import 'package:flutter_crm_prove/domain/Task/task.dart';
import 'package:test/test.dart';

class RepositoryTest {
}

void main() {
  group('Repository test', () {
    late RepositoryCrm repository;
    late RepositoryProject repositoryProject;
    late OdooClient odooClient;
    int id = 47;

    setUpAll(() async {
      odooClient = OdooClient();
      repository = RepositoryCrm(odooClient: odooClient);
      repositoryProject = RepositoryProject(odooClient: odooClient);
      await repository.login('https://demos15.aurestic.com', 'admin', 'admin', 'demos_demos15');
    });

    test('Login test', () async {
      expect(odooClient.jsonRpcClient.sessionId, isNotNull);
      if (kDebugMode) {
        print(odooClient.jsonRpcClient.sessionId);
      }
    });

    test('Read Lead test', () async {
      Lead lead = await repository.listLead('crm.lead', 25);
      if (kDebugMode) {
        print(lead.toString());
      }
    });

    test('List leads test', () async {
      List<Lead> leads = await repository.listLeads('crm.lead', [['priority', '>=', 0]], {});
      if (leads.isNotEmpty) {
        if (kDebugMode) {
          for (Lead lead in leads) {
            print(lead.toString());
          }
        }
        expect(leads.length, greaterThan(0));
      } else {
        if (kDebugMode) {
          print('No leads found with expected revenue greater than 1000');
        }
      }
    });

    test('Create lead test', () async {
      CreateResponse createResponse = await repository.createLead('crm.lead', {
        'name': 'PruebaParaProbarEditar',
        'description': 'Prueba2',
        'partner_id': 1,
        'phone': '+123456789',
        'email_from': 'correo@example.com',
        'company_id': 1,
        'user_id': 2,
        'date_deadline': '2024-12-31',
        'team_id': 1,
        'expected_revenue': 100000,
        'tag_ids': [1, 2, 3],
        'priority': '1',
        'probability': 90,
        'create_date': '2024-03-25',
        'stage_id': 1,
      });

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

    test('Update lead test', () async {
      Lead lead = Lead(id: id, name: 'EDITADODENUEVo', stageId: 2, priority: '3', expectedRevenue: 65359, tagIds: [1], probability: 95);
      WriteResponse updateResponse = await repository.updateLead('crm.lead', id, lead);
      expect(updateResponse.success, true);
      if (kDebugMode) {
        print(updateResponse.success);
      }
    });

    test('tagName test', () async {
      List<String> tagNames = await repository.getNamesByIds('crm.tag', [1, 2, 3, 4, 5, 6, 7, 8]);
      expect(tagNames, ['Producto', 'Software', 'Servicios', 'Información', 'Diseño', 'Formación', 'Consultoría', 'Otro']);

      if (kDebugMode) {
        for (int i = 0; i < tagNames.length; i++) {
          print('Tag ${i + 1}: ${tagNames[i]}');
        }
      }
    });

    test('stageNameById test', () async {
      String stageNames = await repository.getNameById('crm.stage', 2);
      expect(stageNames, 'Calificado');
      String clientName = await repository.getNameById('res.partner', 1);
      expect(clientName, 'My Company (San Francisco)');

      if (kDebugMode) {
        print('Stage 2: $clientName');
      }
    });

    test('stageIdByName test', () async {
      int stageId = await repository.getIdByName('crm.stage', 'Propuesta');
      expect(stageId, 3);
      int tagId = await repository.getIdByName('crm.tag', 'Producto');
      expect(tagId, 1);
      int idPartner = await repository.getIdByName('res.partner', 'Henry Jordan');
      expect(idPartner, 46);
    });

    test('stageName test', () async {
      List<String> stageNames = (await repository.getAllNames('crm.stage', ['name'])).cast<String>();
      expect(stageNames, ['Nuevo', 'Calificado', 'Propuesta', 'Ganado']);

      if (kDebugMode) {
        for (int i = 0; i < stageNames.length; i++) {
          print('Stage ${i + 1}: ${stageNames[i]}');
        }
      }
    });

    test('get clients - get all names test', () async {
      List<String> clients = (await repository.getAllNames('res.partner', ['name'])).cast<String>();
      if (kDebugMode) {
        print('Clients: $clients');
      }
    });

    test('get clients - get all for model test', () async {
      List<Map<String, dynamic>> teams = await repository.getAllForModel('crm.team', ['id', 'name']);
      if (kDebugMode) {
        print('Teams: $teams');
      }
    });

    test('get clients - get name by id test', () async {
      String team = await repository.getNameById('crm.team', 15);
      if (kDebugMode) {
        print('Team: $team');
      }
    });

    test('get clients - get id by name test', () async {
      int teamId = await repository.getIdByName('crm.team', 'Pre-Sales');
      if (kDebugMode) {
        print('Team: $teamId');
      }
    });

    test('get clients - other tests', () async {
      List<String> users = (await repository.getAllNames('res.users', ['name'])).cast<String>();
      List<String> companies = (await repository.getAllNames('res.company', ['name'])).cast<String>();
      List<String> tags = (await repository.getAllNames('crm.tag', ['name'])).cast<String>();
      List<String> stages = (await repository.getAllNames('crm.stage', ['name'])).cast<String>();
      List<dynamic> ids = await repository.getAllForModel('res.users', ['id', 'name']);
      List<Map<String, dynamic>> idss = await repository.getAllForModel('crm.team', ['id', 'name']);
      String user = await repository.getNameById('res.users', 8);
      int userId = await repository.getIdByName('res.users', 'CAMILO MORENO');

      if (kDebugMode) {
        print('Users: $users');
        print('Companies: $companies');
        print('Tags: $tags');
        print('Stages: $stages');
        print('Ids: $ids');
        for (var team in idss) {
          print('Id ${team['name']}, ${team['id']}');
        }
        print('Id: $userId');
        print('User: $user');
      }
    });
  });
}
