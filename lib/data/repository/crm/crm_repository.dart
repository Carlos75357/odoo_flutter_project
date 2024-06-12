import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:flutter_crm_prove/data/repository/data_source.dart';
import 'package:flutter_crm_prove/data/repository/crm/crm_repository_response.dart';

import '../../../domain/crm/lead.dart';

class RepositoryCrm extends RepositoryDataSource {
  OdooClient odooClient;
  RepositoryCrm({required this.odooClient});

  @override
  Future<LoginResponse> login(String url, String username, String password, String db) async {
    var response = await odooClient.authenticate(url, username, password, db);
    if (response['sessionId'] == null) {
      throw Exception('Failed to authenticate');
    }
    return LoginResponse(success: true);
  }

  @override
  Future<Lead> listLead(String model, int id) async {
    try {

      var response = await odooClient.read(model, id, {});

      return Lead.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get lead: $e');
    }
  }

  @override
  Future<List<Lead>> listLeads(String model, List<dynamic> domain, Map<String, dynamic> kwargs) async {
    try {
      var response = await odooClient.searchRead(model, domain, kwargs);

      return response.map((e) => Lead.fromJson(e)).toList();

    } catch (e) {
      throw Exception('Failed to get leads: $e');
    }
  }

  @override
  Future<CreateResponse> createLead(String model, Map<String, dynamic> values) async {
    try {
      var response = await odooClient.create(model, values);
      if (response['result'] == null) {
        throw Exception('Failed to create lead');
      }
      return CreateResponse(success: true);
    } catch (e) {
      throw Exception('Failed to create lead: $e');
    }
  }

  @override
  Future<WriteResponse> updateLead(String model, int id, Lead values) async {
    try {
      var response = await odooClient.write(model, id, values);

      return WriteResponse(success: response);
    } catch (e) {
      throw Exception('Failed to update lead: $e');
    }
  }

  @override
  Future<UnlinkResponse> unlinkLead(String model, int id) async {
    try {
      var response = await odooClient.unlink(model, id);
      return UnlinkResponse(response);
    } catch (e) {
      throw Exception('Failed to unlink lead: $e');
    }
  }

  @override
  Future<List<String>> getNamesByIds(String modelName, List<int>? ids) async {
    List<String> names = [];
    if (ids != null && ids.isNotEmpty) {
      for (var id in ids) {
        try {
          var context = {
            'lang': 'es_ES',
            "active_test": false,
          };

          var kwargs = {
            'context': context,
            'fields': ['id', 'name']
          };

          var response = await odooClient.read(modelName, id, kwargs);

          String? name = response['name'];
          names.add(name!);
        } catch (e) {
          throw Exception('Failed to get name: $e');
        }
      }
    }
    return names;
  }

  @override
  Future<String> getNameById(String modelName, int id) async {
    try {

      var context = {
        'lang': 'es_ES',
        "active_test": false,
      };

      var kwargs = {
        'context': context,
        'fields': ['id', 'name']
      };

      var response = await odooClient.read(modelName, id, kwargs);

      return response['name'];
    } catch (e) {
      if (id == 0) {
        return '';
      } else {
        throw Exception('Failed to get name: $e');
      }
    }
  }

  @override
  Future<int> getIdByName(String modelName, String name) async {
    try {
      int offset = 0;
      int limit = 10;
      while (true) {
        var context = {
          'lang': 'es_ES',
          "active_test": false,
        };

        var kwargs = {
          'context': context,
          'offset': offset,
          'limit': limit,
          'fields': ['id', 'name']
        };

        var response = await odooClient.searchRead(modelName, [['name', '=', name]], kwargs);
        if (response.isEmpty) {
          return 0;
        }

        var record = response.firstWhere(
                (record) => record['name'] == name
        );

        if (record != null) {
          return record['id'] as int;
        }

        offset += limit;
      }
    } catch (e) {
      return 0;
    }
  }

  @override
  Future<List<int>> getIdsByNames(String modelName, List<String> names) async {
    try {
      List<int> ids = [];
      int offset = 0;
      int limit = 10;

      var fields = ['id', 'name'];
      while (true) {
        var context = {
          'lang': 'es_ES',
          "active_test": false,
        };

        var kwargs = {
          'context': context,
          'offset': offset,
          'limit': limit,
          'fields': fields
        };

        var domain = [['name', 'in', names]];
        var response = await odooClient.searchRead(modelName, domain, kwargs);
        if (response.isEmpty) {
          break;
        }

        for (var record in response) {
          ids.add(record['id'] as int);
        }

        offset += limit;
      }

      return ids;
    } catch (e) {
      return [];
    }
  }

  Future<List<int>> getIds(String modelName, List<String> fields) async {
    try {
      List<int> ids = [];
      int offset = 0;
      int limit = 10;

      var fields = ['id', 'name'];
      while (true) {
        var context = {
          'lang': 'es_ES',
          "active_test": false,
        };

        var kwargs = {
          'context': context,
          'offset': offset,
          'limit': limit,
          'fields': fields
        };

        var domain = [];
        var response = await odooClient.searchRead(modelName, domain, kwargs);
        if (response.isEmpty) {
          break;
        }

        for (var record in response) {
          if (record.containsKey('id')) {
            ids.add(record['id'] as int);
          }
        }

        offset += limit;
      }

      return ids;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllForModel(String modelName, List<String> fields) async {
    try {
      var response = await odooClient.searchRead(modelName, [], {
        'fields': fields,
      });

      if (response == null || response.isEmpty) {
        return [];
      }

      return response.map<Map<String, dynamic>>((record) {
        return {
          'id': record['id'] ?? 0,
          'name': record['name'] ?? 'Unknown',
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to get records: $e');
    }
  }

  @override
  Future<List<String>> getAllNames(String modelName, List<String> fields) async {
    List<String> names = [];
    try {
      var context = {
        'lang': 'es_ES',
        "active_test": false,
      };

      var kwargs = {
        'context': context,
        'fields': fields
      };

      var response = await odooClient.searchRead(modelName, [], kwargs);

      var validNames = response
          .where((record) => record['name'] != false)
          .map((record) => record['name'] as String)
          .toList();

      names.addAll(validNames);
      return names;
    } catch (e) {
      throw Exception('Failed to get names: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAll(String model) async {
    try {
      var response = await odooClient.searchRead(model, [], {});

      if (response == null || response.isEmpty) {
        return [];
      }

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to get records: $e');
    }
  }
}