import 'package:flutter_crm_prove/data/repository/crm/crm_repository_response.dart';
import 'package:flutter_crm_prove/data/repository/data_source.dart';
import 'package:flutter_crm_prove/domain/Task/task.dart';

import '../../json/odoo_client.dart';

class TaskRepository extends TaskRepositoryDataSource {
  OdooClient odooClient;
  TaskRepository({required this.odooClient});

  @override
  Future<Task> listTask(String modelName, int id) async {
    try {
      var response = await odooClient.read(modelName, id, {});

      return Task.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get task: $e');
    }
  }

  @override
  Future<List<Task>> listTasks(String modelName, List<dynamic> domain, Map<String, dynamic> kwargs) async {
    try {
      var response = await odooClient.searchRead(modelName, domain, kwargs);

      return response.map((task) => Task.fromJson(task)).toList();
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }

  @override
  Future<CreateResponse> createTask(String model, Map<String, dynamic> values, int id) async {
    try {
      values['project_id'] = id;
      var response = await odooClient.create(model, values);

      if (response['result'] == null) {
        throw Exception('Failed to create task');
      }

      return CreateResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  @override
  Future<UnlinkResponse> unlinkTask(String model, int id) async {
    try {
      var response = await odooClient.unlink(model, id);

      return UnlinkResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  @override
  Future<WriteResponse> updateTask(String model, int id, Task values) async {
    try {
      var response = await odooClient.write(model, id, values);

      return WriteResponse(success: response);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getAll(String modelName, List<String> fields, List domain) async {
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
  Future<int> getIdByName(String modelName, String name) async {
    try {
      int offset = 0;
      int limit = 10;
      while (true) {
        var context = {
          'lang': 'es_ES',
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