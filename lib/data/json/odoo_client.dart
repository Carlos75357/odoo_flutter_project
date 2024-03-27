import 'package:flutter_crm_prove/data/odoo_config.dart';
import 'package:flutter_crm_prove/data/repository/data_source.dart';
import '../../domain/lead.dart';

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

  /// Authenticate method, send credentials to login in Odoo, if credentials
  /// are correct saves sessionId in sessionId variable to be used in other methods.
  @override
  Future<Map<String, dynamic>> authenticate(String url, String username, String password) async {
    var jsonRequest = JsonRequest({
      'db': 'demos_demos15',
      'login': username,
      'password': password
    });

    try {
      this.url = url;
      OdooConfig.setBaseUrl(url);
      var response = await call('$url/web/session/authenticate', jsonRequest);

      if (response.containsKey('error')) {
        throw Exception('Failed to authenticate: ${response['error']}');
      }

      return response;

    } catch (e) {
      throw Exception('Failed to authenticate: $e');
    }
  }

  /// SearchRead method, send domain to search in Odoo all records that match
  /// with the domain
  @override
  Future<List<Map<String, dynamic>>> searchRead(String model, List<dynamic> domain) async {
    var jsonRequest = JsonRequest({
      'model': model,
      'method': 'search_read',
      'args': [domain],
      'kwargs': {'context': []},
    });

    try {
      String urlToPut = '$url/web/dataset/search_read';
      var response = await call(urlToPut, jsonRequest);

      List<dynamic> records = response['result']['records'];
      if (records.isNotEmpty) {
        return records.map((record) => record as Map<String, dynamic>).toList();
      } else {
        throw Exception('No records found');
      }
    } catch (e) {
      throw Exception('Failed to perform search_read: $e');
    }
  }


  /// Read method, read the records with the given ids from the given model,
  /// in args must be the id and in kwargs the fields that you want to read
  /// in this case is empty, which means that it will read all the fields
  @override
  Future<Map<String, dynamic>> read(String model, int id) async {
    var jsonRequest = JsonRequest({
      'model': model,
      'method': 'read',
      'args': [id],
      'kwargs': {'fields': [], 'context': []},
    });
    try {

      var response = await call('$url/web/dataset/call_kw/crm/read', jsonRequest);

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


  /// Unlink the record with the given id from the given model
  @override
  Future<bool> unlink(String model, int id) async {
    try {
      var jsonRequest = JsonRequest({
        'model': model,
        'method': 'unlink',
        'args': [id],
        'kwargs': {'context': []},
      });

      var response = await call('$url/web/dataset/call_kw/crm/unlink', jsonRequest);
      bool result = response['result'];

      return result;
        } catch (e) {
      throw Exception('Error al intentar eliminar el registro: $e');
    }
  }


  /// Write method, update the record with the given id.
  @override
  Future<bool> write(String model, int id, Lead values) async {
    var jsonRequest = JsonRequest({
      'model': model,
      'method': 'write',
      'args': [id, values.toJson()],
      'kwargs': {'context': []},
    });

    try {
      var response = await call('$url/web/dataset/call_kw/crm/write', jsonRequest);

      dynamic result = response['result'];

      return result;
    } catch (e) {
      throw Exception('Error al intentar actualizar el registro: $e');
    }
  }


  /// Create method, create a new record in the given model with the given values
  @override
  Future<Map<String, dynamic>> create(String model, Map<String, dynamic> values) async {
    var jsonRequest = JsonRequest({
      'model': model,
      'method': 'create',
      'args': [values],
      'kwargs': {'context': []},
    });

    try {
      var response = await call('$url/web/dataset/call_kw/crm/create', jsonRequest);
      print(response);
      return response;
    } catch (e) {
      throw Exception('Failed to create record: $e');
    }
  }
}