import 'package:flutter_crm_prove/data/repository_data_source.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Repository extends RepositoryDataSource {
  String? sessionId;
  String? url;
  String? db;

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



// @override
  // Future<UnlinkResponse> unlink(String model, List<int> ids) {
  //   // TODO: implement unlink
  //   throw UnimplementedError();
  // }
  //
  // @override
  // Future<WriteResponse> write(String model, List<int> ids, Map<String, dynamic> values) {
  //   // TODO: implement write
  //   throw UnimplementedError();
  // }
}
