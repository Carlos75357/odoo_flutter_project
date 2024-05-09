import 'package:flutter_crm_prove/data/odoo_config.dart';
import 'package:flutter_crm_prove/data/repository/data_source.dart';
import '../../domain/lead.dart';

import 'json_client.dart';
import 'json_rpc.dart';

/// Class [OdooClient] interact with the Odoo server, based on http package have
/// methods to [authenticate], [searchRead], [read], [unlink], [write], [create]
class OdooClient extends OdooDataSource{
  /// Class [JsonRpcClient] to handle calls and responses from json rpc.
  JsonRpcClient jsonRpcClient = JsonRpcClient();
  /// [url] is the url of the Odoo server.
  String? url;
  String? db;

  /// [call] method it receives a [url] and a [jsonRequest] and returns a [JsonRpcClient]
  /// [response].
  Future<Map<String, dynamic>> call(String url, JsonRequest jsonRequest) async {
    try {
      var response = await jsonRpcClient.call(url, jsonRequest);
      return response;
    } catch (e) {
      throw Exception('Failed to authenticate: $e');
    }

  }

  /// [setSettings] method, set [url] and [sessionId] variables.
  void setSettings(String url, String sessionId) {
    this.url = url;
    jsonRpcClient.sessionId = sessionId;
  }

  /// [authenticate] method, send credentials to login in Odoo, if credentials
  /// are correct saves [sessionId] in [sessionId] variable to be used in other methods.
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

  /// [searchRead] method, send domain to search in Odoo all records that match
  /// with the domain
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


  /// [read] method, read the records with the given ids from the given model,
  /// in args must be the id and in kwargs the fields that you want to read
  /// in this case is empty, which means that it will read all the fields
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


  /// [unlink] the record with the given id from the given model
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


  /// [write] method, update the record with the given id.
  @override
  Future<bool> write(String model, int id, Lead values) async {
    Map<String, dynamic> valuesMap = values.toJson();
    var jsonRequest = JsonRequest({
      'model': model,
      'method': 'write',
      'args': [id, valuesMap],
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
      var response = await call('$url/web/dataset/call_kw/crm/create', jsonRequest);
      return response;
    } catch (e) {
      throw Exception('Failed to create record: $e');
    }
  }
}