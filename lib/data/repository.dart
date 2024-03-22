import 'package:flutter_crm_prove/data/repository_data_source.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
/// Class api to interact with Odoo, based on http package have methods to authenticate, searchRead, read, unlink, write, create
class Repository extends RepositoryDataSource {
  String? sessionId;
  String? url;
  String? db;

  /// Authenticate method, send credentials to login in Odoo, if credentials
  /// are correct saves sessionId in sessionId variable to be used in other methods.
  @override
  Future<LoginResponse> authenticate(String url, String db, String username, String password) async {
    var jsonRequest = JsonRequest({
      'db': 'demos_demos15',
      'login': username,
      'password': password
    });

    try {
      this.url = url;
      this.db = db;

      var response = await call('/web/session/authenticate', jsonRequest);

      return LoginResponse.fromJson(response['result']);

    } catch (e) {
      throw Exception('Failed to authenticate: $e');
    }
  }

  /// SearchRead method, send domain to search in Odoo all records that match
  /// with the domain
  @override
  Future<List<CrmLead>> searchRead(String model, List<dynamic> domain) async {
    var jsonRequest = JsonRequest({
      'model': model,
      'method': 'search_read',
      'args': [domain],
      'kwargs': {'context': []},
    });

    try {

      var response = await call('/web/dataset/search_read', jsonRequest);

      List<dynamic> records = response['result']['records'];
      if (records.isNotEmpty) {
        return records.map((record) => CrmLead.fromJson(record)).toList();
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
  Future<CrmLead> read(String model, int id) async {
    var jsonRequest = JsonRequest({
      'model': model,
      'method': 'read',
      'args': [id],
      'kwargs': {'fields': [], 'context': []},
    });
    try {

      var response = await call('/web/dataset/call_kw/crm/read', jsonRequest);

      List<dynamic> records = response['result'];
      for (var record in records) {
        if (record['id'] == id) {
          return CrmLead.fromJson(record);
        }
      }
      throw Exception('No record found with id $id');
        } catch (e) {
      throw Exception('Failed to read record: $e');
    }
  }


  /// Unlink the record with the given id from the given model
  @override
  Future<UnlinkResponse> unlink(String model, int id) async {
    try {
      var jsonRequest = JsonRequest({
        'model': model,
        'method': 'unlink',
        'args': [id],
        'kwargs': {'context': []},
      });

      var response = await call('/web/dataset/call_kw/crm/unlink', jsonRequest);

      dynamic result = response['result'];

      if (result != null) {
        return UnlinkResponse([result]);
      } else {
        throw Exception('No se pudo eliminar el registro.');
      }
        } catch (e) {
      throw Exception('Error al intentar eliminar el registro: $e');
    }
  }


  /// Write method, update the record with the given id.
  @override
  Future<WriteResponse> write(String model, int id, CrmLead values) async {
    var jsonRequest = JsonRequest({
      'model': model,
      'method': 'write',
      'args': [id, values.toJson()],
      'kwargs': {'context': []},
    });

    try {
      var response = await call('/web/dataset/call_kw/crm/write', jsonRequest);

      dynamic result = response['result'];

      if (result != null) {
        return WriteResponse(success: true, id: result);
      } else {
        return WriteResponse(success: false);
      }
    } catch (e) {
      throw Exception('Error al intentar actualizar el registro: $e');
    }
  }


  /// Create method, create a new record in the given model with the given values
  @override
  Future<CreateResponse> create(String model, Map<String, dynamic> values) async {
    var jsonRequest = JsonRequest({
      'model': model,
      'method': 'create',
      'args': [values],
      'kwargs': {'context': []},
    });

    try {
      var response = await call('/web/dataset/call_kw/crm/create', jsonRequest);
      return CreateResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create record: $e');
    }
  }



  /// TagNames method, get the names of the tags with the given ids
  Future<List<String>> tagNames(List<dynamic>? tagIds) async {
    List<String> tagNames = [];
    if (tagIds != null && tagIds.isNotEmpty) {
      for (var tagId in tagIds) {
        var jsonRequest = JsonRequest({
          'model': 'crm.tag',
          'method': 'read',
          'args': [tagId],
          'kwargs': {'fields': ['name'], 'context': []},
        });
        try {
          var response = await call('/web/dataset/call_kw/tags/read', jsonRequest);

          String tagName = response['result'][0]['name'];
          tagNames.add(tagName);
        } catch (e) {
          throw Exception('Failed to get tag name: $e');
        }
      }
    }
    return tagNames;
  }

  Future<Map<String, dynamic>> call(String url, JsonRequest jsonRequest) async {
    try {
      var header = {
        'Content-Type': 'application/json',
      };

      if (sessionId != null) {
        header = {
          'Content-Type': 'application/json',
          'Cookie': sessionId ?? '',
        };
      }

      final request = jsonEncode(jsonRequest.toJson());

      final response = await http.post(
        Uri.parse(this.url !+ url),
        headers: header,
        body: request,
      );

      if (url.endsWith('authenticate')) {
        List<String> parts = response.headers['set-cookie']?.split(";") ?? [];

        String? sessionIdPart = parts
            .firstWhere((part) => part.trim().startsWith("session_id="), orElse: () => "");

        sessionId = sessionIdPart.trim();
      }

      if (response.statusCode == 200) {
        final responseToMap = jsonDecode(response.body);
        return responseToMap;
      } else {
        throw Exception('Failed to call remote API with status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to call remote API: $e');
    }
  }
}

class JsonRequest {
  var jsonrpc;
  var method;
  var params;

  JsonRequest(Map map) {
    jsonrpc = "2.0";
    method = 'call';
    params = map;
  }

  factory JsonRequest.fromJson(Map<String, dynamic> json) {
    return JsonRequest(json['result']);
  }

  Map<String, dynamic> toJson() {
    return {
      'jsonrpc': jsonrpc,
      'method': method,
      'params': params,
    };
  }
}