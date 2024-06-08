import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_crm_prove/data/odoo_config.dart';

import 'json_rpc.dart';
import 'package:http/http.dart' as http;

class JsonRpcClient {
  var sessionId = '';

  Future<Map<String, dynamic>> call(String url, JsonRequest jsonRequest) async {
    try {

      var header = {
        'Content-Type': 'application/json',
      };

      if (sessionId != '') {
        header = {
          'Content-Type': 'application/json',
          'Cookie': sessionId,
        };
      }

      final request = jsonEncode(jsonRequest.toJson());

      print(request);

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
        print(responseToMap);
        return responseToMap;
      } else {
        FirebaseCrashlytics.instance.recordError(Exception('Ha habido un error con el servidor, número del error: ${response.statusCode}'), null, fatal: true);
        throw Exception('Failed to call remote API with status code ${response.statusCode}');
      }
    } catch (e) {
      FirebaseCrashlytics.instance.recordError(e, null, fatal: true);
      throw Exception('Failed to call remote API: $e');
    }
  }
}