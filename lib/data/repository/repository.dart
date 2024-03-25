import 'package:flutter_crm_prove/data/json/odoo_client.dart';
import 'package:flutter_crm_prove/data/repository/data_source.dart';
import 'package:flutter_crm_prove/data/repository/repository_response.dart';

/// Class api to interact with Odoo, based on http package have methods to authenticate, searchRead, read, unlink, write, create
class Repository extends RepositoryDataSource {
  OdooClient odooClient = OdooClient();
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
  Future<CrmLead> listLead(String model, int id) async {
    try {
      var response = await odooClient.read(model, id);
      return CrmLead.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get lead: $e');
    }
  }

  @override
  Future<List<CrmLead>> listLeads(String model, List domain) async {
    try {
      var response = await odooClient.searchRead(model, domain);
      return response.map((record) => CrmLead.fromJson(record)).toList();
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
}