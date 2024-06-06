import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:flutter_crm_prove/data/repository/crm/crm_repository_response.dart';
import 'package:flutter_crm_prove/data/repository/data_source.dart';

import '../../../domain/project/project.dart';

class RepositoryProject extends ProjectRepositoryDataSource {
  OdooClient odooClient;
  RepositoryProject({required this.odooClient});

  @override
  Future<Project> listProject(String modelName, int id) async {
    try {
      var response = await odooClient.read(modelName, id, {});

      return Project.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get project: $e');
    }
  }

  @override
  Future<List<Project>> listProjects(String modelName, List<dynamic> domain, Map<String, dynamic> kwargs) async {
    try {
      var response = await odooClient.searchRead(modelName, domain, kwargs);

      return response.map((project) => Project.fromJson(project)).toList();
    } catch (e) {
      throw Exception('Failed to get projects: $e');
    }
  }

  @override
  Future<CreateResponse> createProject(String model, Map<String, dynamic> values) async {
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
  Future<UnlinkResponse> unlinkProject(String model, int id) async {
    try {
      var response = await odooClient.unlink(model, id);

      return UnlinkResponse(response);
    } catch (e) {
      throw Exception('Failed to delete lead: $e');
    }
  }

  @override
  Future<WriteResponse> updateProject(String model, int id, Project values) async {
    try {
      var response = await odooClient.write(model, id, values);

      return WriteResponse(success: response);
    } catch (e) {
      throw Exception('Failed to update lead: $e');
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

  @override
  Future<Map<String, dynamic>> getAll(String modelName, List<String> fields, List<dynamic> domain) async {
    try {
      var context = {
        'lang': 'es_ES',
        "active_test": false,
      };

      var kwargs = {
        'context': context,
        'fields': fields

      };

      var response = await odooClient.searchRead(modelName, [domain], kwargs);
      Map<String, dynamic> records = {
        'records': response
      };
      return records;

    } catch (e) {
      throw Exception('Failed to get names: $e');
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

  Future<int> getStageIdByName(String modelName, String name, List<int> allowedIds) async {
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

        var record = response.firstWhere((record) => record['name'] == name && allowedIds.contains(record['id']));

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
  Future<List<int>> getIdsByName(String modelName, List<String> names) async {
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
}