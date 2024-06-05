import 'package:flutter/foundation.dart';
import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:flutter_crm_prove/data/repository/crm/crm_repository.dart';
import 'package:flutter_crm_prove/data/repository/crm/crm_repository_response.dart';
import 'package:flutter_crm_prove/data/repository/project/pjt_repository.dart';
import 'package:flutter_crm_prove/domain/crm/lead.dart';
import 'package:flutter_crm_prove/domain/Task/task.dart';
import 'package:test/test.dart';

class RespositoryTest {
}

void main() {
  group('Respository test', () {
    late RepositoryCrm repository;
    late RepositoryProject repositoryProject;
    late OdooClient odooClient;
    int id = 47; //174

    setUpAll(() async {
      odooClient = OdooClient();
      repository = RepositoryCrm(odooClient: odooClient);
      repositoryProject = RepositoryProject(odooClient: odooClient);
      // await repository.login('https://testcoimasa15.aurestic.com', 'marketing@coimasa.com', 'marketing@coimasa.com', 'coimasa15.0_migrated_pruebas');
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
      // expect(lead.id, id);
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
      // CreateResponse createResponse = await repository.createLead('crm.lead', {'name': 'Prueba2', 'description': 'Prueba2', 'expected_revenue': 100000});
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
    //
    test('Unlink lead test', () async {
      UnlinkResponse unlinkResponse = await repository.unlinkLead('crm.lead', id);
      expect(unlinkResponse.records, true);
      if (kDebugMode) {
        print(unlinkResponse.records);
      }
    });
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
      expect(tagNames[0], 'Producto');
      expect(tagNames[1], 'Software');
      expect(tagNames[2], 'Servicios');
      expect(tagNames[3], 'Información');
      expect(tagNames[4], 'Diseño');
      expect(tagNames[5], 'Formación');
      expect(tagNames[6], 'Consultoría');
      expect(tagNames[7], 'Otro');

      if (kDebugMode) {
        for (int i = 0; i < tagNames.length; i++) {
          print('Tag ${i + 1}: ${tagNames[i]}');
        }
      }
    });

    test('stageNameById test', () async {
      String stageNames = await repository.getNameById('crm.stage',2);
      expect(stageNames, 'Calificado');
      String clientName = await repository.getNameById('res.partner',1);
      expect(clientName, 'My Company (San Francisco)');

      if (kDebugMode) {
        print('Stage 2: $clientName');
      }
    });

    test('stageIdByName test', () async {
      int stageId = await repository.getIdByName('crm.stage','Propuesta');
      if (kDebugMode) {
        print('Stage $stageId: $stageId');
      }
      expect(stageId, 3);
      int tagId = await repository.getIdByName('crm.tag','Producto');
      if (kDebugMode) {
        print('Tag $tagId: $tagId');
      }
      expect(tagId, 1);
      int idPartner = await repository.getIdByName('res.partner','Henry Jordan');
      if (kDebugMode) {
        print('Partner $idPartner: $idPartner');
        String name = await repository.getNameById('res.partner', idPartner);
        print('Partner $idPartner: $name');
        List<String> names = await repository.getNamesByIds('res.partner', [idPartner]);
        print('Partner $idPartner: $names');
      }
      expect(idPartner, 46);
    });

    test('stageName test', () async {
      List<String> stageNames = (await repository.getAllNames('crm.stage', ['name'])).cast<String>();
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

      // List<String> a = await repository.getAllNames('res.users', ['name']);
      // List<String> b = await repository.getAllNames('res.partner', ['name']);
      // List<String> c = await repository.getAllNames('crm.team', ['name']);
      // List<String> d = await repository.getAllNames('crm.lead', ['name']);
      // List<String> e = await repository.getAllNames('crm.stage', ['name']);
      //
      // if (kDebugMode) {
      //   print('a: $a');
      //   print('b: $b');
      //   print('c: $c');
      //   print('d: $d');
      //   print('e: $e');
      // }

      // String name = await repository.getNameById('res.partner', id);
      // if (kDebugMode) {
      //   print('Name: $name');
      // }
      //
      // List<Map<String, dynamic>> clients = await repository.getAllForModel('res.partner', ['id', 'name']);
      //
      // if (kDebugMode) {
      //   print('Clients: $clients');
      // }

      Map<String, dynamic> a = await repositoryProject.getAll('project.task', [], ['project_id', '=', 8]);
      List<Task> tasks = a['records'].map<Task>((task) => Task.fromJson(task)).toList();
      if (kDebugMode) {
        print('a: $a');
      }

      // List<String> clients = (await repository.getAllNames('res.partner', ['name'])).cast<String>();
      //
      // if (kDebugMode) {
      //   print('Clients: $clients');
      // }
      // List<Map<String, dynamic>> teams = await repository.getAllForModel('crm.team', ['id', 'name']);
      //
      // if (kDebugMode) {
      //   print('Teams: $teams');
      // }
      //
      // List<String> teamsNames = await repository.getAllNames('crm.team', ['name']);
      //
      // if (kDebugMode) {
      //   print('Team: $teamsNames');
      // }

      // int teamId = await repository.getIdByName('crm.team', 'Pre-Sales');
      //
      // if (kDebugMode) {
      //   print('Team: $teamId');
      // }

      // String team = await repository.getNameById('crm.team', 15);
      //
      // if (kDebugMode) {
      //   print('Team: $team');
      // }

      //
      // List<String> y = (await repository.getAllNames('res.users', ['name'])).cast<String>();
      //
      // if (kDebugMode) {
      //   print('Users: $y');
      // }
      //
      // List<String> x = (await repository.getAllNames('res.company', ['name'])).cast<String>();
      //
      // if (kDebugMode) {
      //   print('Companies: $x');
      // }
      //
      // List<String> z = (await repository.getAllNames('crm.tag', ['name'])).cast<String>();
      //
      // if (kDebugMode) {
      //   print('Tags: $z');
      // }
      //
      // List<String> w = (await repository.getAllNames('crm.stage', ['name'])).cast<String>();
      //
      // if (kDebugMode) {
      //   print('Stages: $w');
      // }
      //
      // List<String> t = (await repository.getAllNames('res.users', ['name'])).cast<String>();
      //
      // if (kDebugMode) {
      //   print('Users: $t');
      // }

      // String a = await repository.getNameById('res.users', 8);
      // int aa = await repository.getIdByName('res.users', 'CAMILO MORENO');
      // if (kDebugMode) {
      //   print('Id: $aa');
      // }
      //
      // if (kDebugMode) {
      //   print('User: $a');
      // }

    //   List<dynamic> ids = await repository.getAllForModel('res.users', ['id', 'name']);
    //
    //   if (kDebugMode) {
    //     print('Ids: $ids');
    //   }
    //
    //   List<Map<String, dynamic>> idss = await repository.getAllForModel('crm.team', ['id', 'name']);
    //
    //   if (kDebugMode) {
    //     for (var team in idss) {
    //       print('Id ${team['name']}, ${team['id']}');
    //     }
    //   }
    });
  });
}