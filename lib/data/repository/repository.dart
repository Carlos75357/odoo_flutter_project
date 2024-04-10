import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:flutter_crm_prove/data/repository/data_source.dart';
import 'package:flutter_crm_prove/data/repository/repository_response.dart';

import '../../domain/lead.dart';

/// Class api to interact with Odoo, based on http package have methods to authenticate, searchRead, read, unlink, write, create
class Repository extends RepositoryDataSource {
  OdooClient odooClient;
  Repository({required this.odooClient});

  @override
  Future<LoginResponse> login(String url, String username, String password) async {
    var response = await odooClient.authenticate(url, username, password);
    if (response['sessionId'] == null) {
      throw Exception('Failed to authenticate');
    }
    return LoginResponse(success: true);
  }

  @override
  Future<Lead> listLead(String model, int id) async {
    try {
      var response = await odooClient.read(model, id);

      return Lead.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get lead: $e');
    }
  }

  @override
  Future<List<Lead>> listLeads(String model, List<dynamic> domain) async {
    try {
      var response = await odooClient.searchRead(model, domain);

      return response.map((e) => Lead.fromJson(e)).toList();

    } catch (e) {
      throw Exception('Failed to get leads: $e');
    }
  }

  @override
  Future<CreateResponse> createLead(String model, Map<String, dynamic> values) async {
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
  Future<WriteResponse> updateLead(String model, int id, Lead values) async {
    try {
      var response = await odooClient.write(model, id, values);

      return WriteResponse(success: response);
    } catch (e) {
      throw Exception('Failed to update lead: $e');
    }
  }

  @override
  Future<UnlinkResponse> unlinkLead(String model, int id) async {
    try {
      var response = await odooClient.unlink(model, id);
      return UnlinkResponse(response);
    } catch (e) {
      throw Exception('Failed to unlink lead: $e');
    }
  }

  // TODO Get by List<int> id
  @override
  /// TagNames method, get the names of the tags with the given ids
  @override
  Future<List<String>> getNamesByIds(String modelName, List<int>? ids) async {
    List<String> names = [];
    if (ids != null && ids.isNotEmpty) {
      for (var id in ids) {
        try {
          var response = await odooClient.read(modelName, id);

          String? name = response['name'];
          names.add(name!);
        } catch (e) {
          throw Exception('Failed to get name: $e');
        }
      }
    }
    return names;
  }

  // TODO Get
  @override
  Future<String> getNameById(String modelName, int id) async {
    try {
      var response = await odooClient.read(modelName, id);

      return response['name'];
    } catch (e) {
      if (id == 0) {
        return '';
      } else {
        throw Exception('Failed to get name: $e');
      }
    }
  }

  // TODO Get by name
  @override
  Future<int> getIdByName(String modelName, String name) async {
    try {
      var response = await odooClient.searchRead(modelName, []);

      var record = response.firstWhere((record) => record['name'] == name);
      return record['id'] as int;
    } catch (e) {
      return 0;
    }
  }

  // TODO Get alls
  @override
  Future<List<dynamic>> getAllForModel(String modelName, List<String> fields) async {
    try {
      var response = await odooClient.searchRead(modelName, []);
      return response.map<dynamic>((record) {
        return fields.map((field) => record[field]).join(' ');
      }).toList();
    } catch (e) {
      throw Exception('Failed to get records: $e');
    }
  }

  @override
  Future<List<String>> getAllNames(String modelName) async {
    try {
      var response = await odooClient.searchRead(modelName, []);
      return response.map<String>((record) => record['name'] as String).toList();
    } catch (e) {
      throw Exception('Failed to get names: $e');
    }
  }

  @override
  Future<List<String>> getAll(String modelName) async {
    try {
      var response = await odooClient.searchRead(modelName, []);
      return response.map<String>((record) => record['name'] as String).toList();
    } catch (e) {
      throw Exception('Failed to get all data: $e');
    }
  }

}