import 'package:flutter/foundation.dart';
import 'package:flutter_crm_prove/data/repository_data_source.dart';
import 'package:flutter_crm_prove/data/repository.dart';
import 'package:test/test.dart';

class RepositoryTest {
}
void main() async {
  group('Repository test', () {
    late Repository repository;
    int id = 64;

    setUpAll(() async {
      repository = Repository();
      await repository.authenticate('https://demos15.aurestic.com', 'demos_demos15', 'admin1', 'admin');
    });

    test('Authenticate test', () async {
      expect(repository.sessionId, isNotNull);
    });

    test('SearchRead test', () async {
      SearchResponse searchResponse = await repository.searchRead('crm.lead', [['expected_revenue', '>', 1000]]);
      expect(searchResponse.records.length, greaterThan(0));
      for (var i = 0; i < searchResponse.records.length; i++) {
        String name = searchResponse.records[i]['name'].toLowerCase();
        if (name.contains('prueba')) {
          if (kDebugMode) {
            print(searchResponse.records[i]);
          }
        }
      }
    });

    test('Read test', () async {
      ReadResponse readResponse = await repository.read('crm.lead', [id]);
      expect(readResponse.records[0], isNotNull);

      if (kDebugMode) {
        print(readResponse.records[0]);
      }
    });

    test('Create test', () async {
      CreateResponse createResponse = await repository.create('crm.lead', {'name': 'Prueba2', 'description': 'Prueba2', 'expected_revenue': 100000});
      if (kDebugMode) {
        print(createResponse.id);
      }
    });

    test('Write test', () async {
      WriteResponse writeResponse = await repository.write('crm.lead', [id], {'name': 'Sobreescrito', 'description': 'Oportunidad sobreescrita.'});

      expect(writeResponse.success, isTrue);

      if (kDebugMode) {
        print('La operación de escritura fue exitosa: ${writeResponse.success}');
        if (writeResponse.success) {
          print('ID del registro actualizado: ${writeResponse.id}');
        }
      }
    });

    test('Unlink test', () async {
      UnlinkResponse unlinkResponse = await repository.unlink('crm.lead', [id]);
      if (kDebugMode) {
        print(unlinkResponse.records[0]);
      }
    });

  });
}
