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
    var response = await http.post(
      Uri.parse('$url/web/session/authenticate'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'jsonrpc': '2.0',
        'params': {
          'db': 'demos_demos15',
          'login': username,
          'password': password
        }
      }),
    );

    if (response.statusCode == 200) {
      List<String> parts = response.headers['set-cookie']?.split(";") ?? [];

      String? sessionIdPart = parts
          .firstWhere((part) => part.trim().startsWith("session_id="), orElse: () => "");

      sessionId = sessionIdPart.trim();
      this.url = url;
      this.db = db;
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  /// SearchRead method, send domain to search in Odoo all records that match
  /// with the domain
  @override
  Future<SearchResponse> searchRead(String model, List<dynamic> domain) async {

    final response = await http.post(
      Uri.parse('$url/web/dataset/search_read'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': sessionId ?? '',
      },
      body: jsonEncode({
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'model': model,
          'domain': domain,
        },
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      List<dynamic> records = responseBody['result']['records'];
      return SearchResponse.fromJson(records);
    } else {
      throw Exception('Failed to perform search_read');
    }
  }

  /// Read method, read the records with the given ids from the given model,
  /// in args must be the id and in kwargs the fields that you want to read
  /// in this case is empty, which means taht it will read all the fields
  @override
  Future<ReadResponse> read(String model, List<int> id) async {
    final response = await http.post(
      Uri.parse('$url/web/dataset/call_kw/crm/read'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': sessionId ?? '',
      },
      body: jsonEncode({
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'model': model,
          'method': 'read',
          'args': [id],
          'kwargs': {'fields': [], 'context': []},
        }
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      dynamic result = responseBody['result'];

      if (result != null) {
        return ReadResponse.fromJson(result);
      } else {
        throw Exception('No records found in the response');
      }
    } else {
      throw Exception('Failed to read records');
    }
  }

  /// Unlink the record with the given id from the given model
  @override
  Future<UnlinkResponse> unlink(String model, List<int> ids) async {
    final response = await http.post(
      Uri.parse('$url/web/dataset/call_kw/crm/unlink'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': sessionId ?? '',
      },
      body: jsonEncode({
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'model': model,
          'method': 'unlink',
          'args': [ids],
          'kwargs': {'context': []},
        }
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      dynamic result = responseBody['result'];

      if (result != null) {
        return UnlinkResponse([result]);
      } else {
        throw Exception('No se pudo eliminar el registro.');
      }
    } else {
      throw Exception('Error al intentar eliminar el registro.');
    }
  }

  /// Write method, update the record with the given id.
  @override
  Future<WriteResponse> write(String model, List<int> ids, Map<String, dynamic> values) async {
    final response = await http.post(
      Uri.parse('$url/web/dataset/call_kw/crm/write'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': sessionId ?? '',
      },
      body: jsonEncode({
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'model': model,
          'method': 'write',
          'args': [ids, values],
          'kwargs': {'context': []},
        }
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      dynamic result = responseBody['result'];

      if (result != null) {
        return WriteResponse(success: true, id: result);
      } else {
        return WriteResponse(success: false);
      }
    } else {
      throw Exception('Error al intentar actualizar el registro.');
    }
  }

  /// Create method, create a new record in the given model with the given values
  @override
  Future<CreateResponse> create(String model, Map<String, dynamic> values) async {
    final response = await http.post(
      Uri.parse('$url/web/dataset/call_kw/crm/create'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': sessionId ?? '',
      },
      body: jsonEncode({
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'model': model,
          'method': 'create',
          'args': [values],
          'kwargs': {'context': []},
        },
      }),
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      return CreateResponse.fromJson(responseBody);
    } else {
      throw Exception('Failed to create record');
    }
  }
}
