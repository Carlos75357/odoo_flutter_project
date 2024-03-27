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
      List<Lead> leads = [];
      for (var record in response) {
        leads.add(Lead.fromJson(record));
      }
      return leads;
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
  Future<UnlinkResponse> unlinkLead(String model, int id) async {
    try {
      var response = await odooClient.unlink(model, id);
      return UnlinkResponse(response);
    } catch (e) {
      throw Exception('Failed to unlink lead: $e');
    }
  }

  @override
  /// TagNames method, get the names of the tags with the given ids
  Future<List<String>> tagNames(List<dynamic>? tagIds) async {
    List<String> tagNames = [];
    if (tagIds != null && tagIds.isNotEmpty) {
      for (var tagId in tagIds) {
        try {
          var response = await odooClient.read('crm.tag', tagId);

          String? tagName = response['name'];
          tagNames.add(tagName!);
        } catch (e) {
          throw Exception('Failed to get tag name: $e');
        }
      }
    }
    return tagNames;
  }

  @override
  Future<String> stageNameById(int stageId) async {
    try {
      var response = await odooClient.read('crm.stage', stageId);

      String? stageName = response['name'];
      return stageName!;
    } catch (e) {
      throw Exception('Failed to get stage name: $e');
    }
  }

  @override
  Future<int> stageIdByName(String stageName) async {
    try {
      var response = await odooClient.searchRead(
        'crm.stage',
        [],
      );

      if (response.isNotEmpty) {
        for (var stage in response) {
          if (stage['name'] == stageName) {
            return stage['id'] as int;
          }
        }
        return 0;
      } else {
        throw Exception('Stage with name "$stageName" not found');
      }
    } catch (e) {
      throw Exception('Failed to get stage ID: $e');
    }
  }

  @override
  Future<Map<String, int>> allStageNamesAndIds() async {
    try {
      var response = await odooClient.searchRead(
        'crm.stage',
        [[]],
      );

      Map<String, int> stageNamesAndIds = {};

      for (var stage in response) {
        int stageId = stage['id'] as int;
        String stageName = stage['name'] as String;
        stageNamesAndIds[stageName] = stageId;
      }

      return stageNamesAndIds;
    } catch (e) {
      throw Exception('Failed to get all stage names and IDs: $e');
    }
  }



  @override
  Future<List<String>> stageNames() async {
    List<String> stageNames = [];

    try {
      var response = await odooClient.searchRead('crm.stage', []);

      for (var record in response) {
        String? stageName = record['name'];
        stageNames.add(stageName!);
      }

      return stageNames;
    } catch (e) {
      throw Exception('Failed to get stage names: $e');
    }
  }
}