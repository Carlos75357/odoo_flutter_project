import 'package:flutter/foundation.dart';
import 'package:flutter_crm_prove/data/repository_data_source.dart';
import 'package:flutter_crm_prove/data/repository.dart';
import 'package:test/test.dart';

class RepositoryTest {
}
void main() async {
  group('Repository test', () {
    late Repository repository;
    int id = 85;

    setUpAll(() async {
      repository = Repository();
      await repository.authenticate('https://demos15.aurestic.com', 'demos_demos15', 'admin1', 'admin');
    });

    test('Authenticate test', () async {
      expect(repository.sessionId, isNotNull);
    });

    test('SearchRead test', () async {
      List<CrmLead> leads = await repository.searchRead('crm.lead', [['expected_revenue', '>', 1000]]);
      expect(leads.length, greaterThan(0));
      for (var lead in leads) {
        if (kDebugMode) {
          print(lead.toString());
        }
      }
    });

    test('Read test', () async {
      CrmLead lead = await repository.read('crm.lead', id);
      expect(lead, isNotNull);
      if (kDebugMode) {
        print(lead);
      }
    });

    test('Create test', () async {
      CreateResponse createResponse = await repository.create('crm.lead', {'name': 'Prueba2', 'description': 'Prueba2', 'expected_revenue': 100000});
      if (kDebugMode) {
        print(createResponse.id);
      }
    });

    test('Write test', () async {

      CrmLead lead = CrmLead(id: id, name: 'sobreescrito');
      WriteResponse writeResponse = await repository.write('crm.lead', id, lead);

      expect(writeResponse.success, isTrue);

      if (kDebugMode) {
        print('La operación de escritura fue exitosa: ${writeResponse.success}');
        if (writeResponse.success) {
          print('ID del registro actualizado: ${writeResponse.id}');
        }
      }
    });

    test('Unlink test', () async {
      UnlinkResponse unlinkResponse = await repository.unlink('crm.lead', id);
      if (kDebugMode) {
        print(unlinkResponse.records[0]);
      }
    });

    test('tagName test', () async {
      List<String> tagNames = await repository.tagNames([1,2,3]);
      expect(tagNames[0], 'Product');
      expect(tagNames[1], 'Software');
      expect(tagNames[2], 'Services');
    });

  });
}
