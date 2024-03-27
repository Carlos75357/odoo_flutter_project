import 'dart:convert';

import 'package:flutter_crm_prove/data/odoo_config.dart';

import 'json_rpc.dart';
import 'package:http/http.dart' as http;

class JsonRpcClient {
  var sessionId;

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
        Uri.parse(url),
        headers: header,
        body: request,
      );

      if (url.endsWith('authenticate')) {
        List<String> parts = response.headers['set-cookie']?.split(";") ?? [];

        String? sessionIdPart = parts.firstWhere(
              (part) => part.trim().startsWith("session_id="),
          orElse: () => "",
        );

        sessionId = sessionIdPart.trim();

        OdooConfig.setSessionId(sessionId);

        final responseToMap = jsonDecode(response.body);
        responseToMap['sessionId'] = sessionId;
        return responseToMap;
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