import 'package:flutter_crm_prove/data/odoo_config.dart';
import 'package:flutter_crm_prove/data/repository/data_source.dart';

import 'json_client.dart';
import 'json_rpc.dart';

class OdooClient extends OdooDataSource{
  JsonRpcClient jsonRpcClient = JsonRpcClient();
  String? url;
  String? db;

  Future<Map<String, dynamic>> call(String url, JsonRequest jsonRequest) async {
    try {
      var response = await jsonRpcClient.call(url, jsonRequest);
      return response;
    } catch (e) {
      throw Exception('Failed to authenticate: $e');
    }

  }

  void setSettings(String url, String sessionId) {
    this.url = url;
    jsonRpcClient.sessionId = sessionId;
  }

  @override
  Future<Map<String, dynamic>> authenticate(String url, String username, String password, String db) async {
    var jsonRequest = JsonRequest({
      'db': db,
      'login': username,
      'password': password
    });

    try {
      this.url = url;
      OdooConfig.setBaseUrl(url);
      OdooConfig.setDb(db);
      var response = await call('$url/web/session/authenticate', jsonRequest);

      if (response.containsKey('error')) {
        throw Exception('Failed to authenticate: ${response['error']}');
      }

      return response;

    } catch (e) {
      throw Exception('Failed to authenticate: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> searchRead(String model, List<dynamic> domain, Map<String, dynamic> kwargs) async {
    var jsonRequest = JsonRequest({
      'model': model,
      'method': 'search_read',
      'args': [domain],
      'kwargs': kwargs
    });

    try {
      String urlToPut = '$url/web/dataset/call_kw';
      var response = await call(urlToPut, jsonRequest);
      List<dynamic> records = response['result'];
      if (records.isNotEmpty) {
        return records.map((record) => record as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to perform search_read: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> read(String model, int id, Map<String, dynamic> kwargs) async {
    var jsonRequest = JsonRequest({
      'model': model,
      'method': 'read',
      'args': [id],
      'kwargs': kwargs,
    });
    try {

      var response = await call('$url/web/dataset/call_kw', jsonRequest);

      List<dynamic> records = response['result'];
      for (var record in records) {
        if (record['id'] == id) {
          return record;
        }
      }
      throw Exception('No record found with id $id');
    } catch (e) {
      throw Exception('Failed to read record: $e');
    }
  }

  @override
  Future<bool> unlink(String model, int id) async {
    try {
      var jsonRequest = JsonRequest({
        'model': model,
        'method': 'unlink',
        'args': [id],
        'kwargs': {'context': []},
      });

      var response = await call('$url/web/dataset/call_kw', jsonRequest);
      bool result = response['result'];

      return result;
    } catch (e) {
      throw Exception('Error al intentar eliminar el registro: $e');
    }
  }

  @override
  Future<bool> write(String model, int id, dynamic values) async {
    Map<String, dynamic> valuesMap = {};
    if (values is Map) {
      values = values as Map<String, dynamic>;
    } else {
      valuesMap = values.toJson();
    }
    var jsonRequest = JsonRequest({
      'model': model,
      'method': 'write',
      'args': [id, valuesMap],
      'kwargs': {'context': []},
    });

    try {
      var response = await call('$url/web/dataset/call_kw', jsonRequest);

      dynamic result = response['result'];

      return result;
    } catch (e) {
      throw Exception('Error al intentar actualizar el registro: $e');
    }
  }


  /// [create] method, create a new record in the given model with the given values
  @override
  Future<Map<String, dynamic>> create(String model, Map<String, dynamic> values) async {
    var jsonRequest = JsonRequest({
      'model': model,
      'method': 'create',
      'args': [values],
      'kwargs': {'context': []},
    });

    try {
      var response = await call('$url/web/dataset/call_kw', jsonRequest);
      return response;
    } catch (e) {
      throw Exception('Failed to create record: $e');
    }
  }
}