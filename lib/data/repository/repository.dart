import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:flutter_crm_prove/data/repository/data_source.dart';
import 'package:flutter_crm_prove/data/repository/repository_response.dart';

import '../../domain/lead.dart';

/// Repository class to interact with Odoo, based on OdooClient.
///
/// This class implements [RepositoryDataSource] to provide methods for
/// [authenticate], [searchRead], [read], [update], [unlink] and [create]
/// in Odoo.
class Repository extends RepositoryDataSource {
  OdooClient odooClient;
  Repository({required this.odooClient});

  /// [login] method it receives a [url] and a [jsonRequest] and returns a [JsonRpcClient]
  /// The method works to authenticate in Odoo.
  @override
  Future<LoginResponse> login(String url, String username, String password) async {
    var response = await odooClient.authenticate(url, username, password);
    if (response['sessionId'] == null) {
      throw Exception('Failed to authenticate');
    }
    return LoginResponse(success: true);
  }

  /// [listLead] method it receives a [model] and a [id] and returns a [Lead].
  /// works to get a [Lead] from Odoo.
  @override
  Future<Lead> listLead(String model, int id) async {
    try {
      var response = await odooClient.read(model, id);

      return Lead.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get lead: $e');
    }
  }

  /// [listLeads] method it receives a [model] and a [domain] and returns a [List<Lead>].
  /// works to get all the [lead] from Odoo.
  @override
  Future<List<Lead>> listLeads(String model, List<dynamic> domain) async {
    try {
      var response = await odooClient.searchRead(model, domain);

      return response.map((e) => Lead.fromJson(e)).toList();

    } catch (e) {
      throw Exception('Failed to get leads: $e');
    }
  }

  /// [createLead] method it receives a [model] and a [values] and returns a [CreateResponse].
  /// works to create a [lead] in Odoo.
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

  /// [updateLead] method it receives a [model] and a [id] and returns a [WriteResponse].
  /// works to update a [lead] in Odoo.
  @override
  Future<WriteResponse> updateLead(String model, int id, Lead values) async {
    try {
      var response = await odooClient.write(model, id, values);

      return WriteResponse(success: response);
    } catch (e) {
      throw Exception('Failed to update lead: $e');
    }
  }

  /// [unlinkLead] method it receives a [model] and a [id] and returns a [UnlinkResponse].
  @override
  Future<UnlinkResponse> unlinkLead(String model, int id) async {
    try {
      var response = await odooClient.unlink(model, id);
      return UnlinkResponse(response);
    } catch (e) {
      throw Exception('Failed to unlink lead: $e');
    }
  }

  /// [getNamesByIds] method it receives a [model] and a [ids] and returns a [List<String>].
  /// works to get names from the ids from Odoo.
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

  /// Method to retrieve the name associated with the given [id] of a lead record in the specified [model].
  ///
  /// Takes [modelName] and [id] as parameters.
  ///
  /// Returns a [Future] containing a [String] representing the name of the lead with the provided [id].
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

  /// Method to retrieve the ID associated with the given [name] of a lead record in the specified [model].
  ///
  /// Takes [modelName] and [name] as parameters.
  ///
  /// Returns a [Future] containing an [int] representing the ID of the lead with the provided [name].
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

  /// Method to retrieve the IDs associated with the given list of [names] of lead records in the specified [model].
  ///
  /// Takes [modelName] and [names] as parameters.
  ///
  /// Returns a [Future] containing a [List<int>] representing the IDs of the leads with the provided names.
  @override
  Future<List<int>> getIdsByNames(String modelName, List<String> name) async {
    try {
      List<int> ids = [];
      var response = await odooClient.searchRead(modelName, []);
      for (var record in response) {
        if (name.contains(record['name'])) {
          ids.add(record['id'] as int);
        }
      }

      return ids;
    } catch (e) {
      return [];
    }
  }

  /// Method to retrieve all records for the specified [modelName] with the specified [fields].
  ///
  /// Takes [modelName] and [fields] as parameters.
  ///
  /// Returns a [Future] containing a [List] of [Map] instances, where each map represents a record.
  /// Each map contains the record's 'id' and 'name' fields.
  ///
  /// Throws an [Exception] if there's a failure while fetching the records.
  @override
  Future<List<Map<String, dynamic>>> getAllForModel(String modelName, List<String> fields) async {
    try {
      var response = await odooClient.searchRead(modelName, []);

      return response.map<Map<String, dynamic>>((record) {
        return {
          'id': record['id'],
          'name': record['name'],
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to get records: $e');
    }
  }

  /// Method to retrieve all names of records for the specified [modelName].
  ///
  /// Takes [modelName] as parameter.
  ///
  /// Returns a [Future] containing a [List] of [String] representing the names of all records for the specified model.
  ///
  /// Throws an [Exception] if there's a failure while fetching the names.
  @override
  Future<List<String>> getAllNames(String modelName) async {
    try {
      var response = await odooClient.searchRead(modelName, []);
      return response.map<String>((record) => record['name'] as String).toList();
    } catch (e) {
      throw Exception('Failed to get names: $e');
    }
  }

  /// Method to retrieve all records for the specified [modelName].
  ///
  /// Takes [modelName] as parameter.
  ///
  /// Returns a [Future] containing a [List] of [String] representing the names of all records for the specified model.
  ///
  /// Throws an [Exception] if there's a failure while fetching the records.
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