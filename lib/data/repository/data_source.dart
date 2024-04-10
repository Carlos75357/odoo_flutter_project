import '../../domain/lead.dart';
import 'repository_response.dart';

abstract class RepositoryDataSource {
  Future<LoginResponse> login(String url, String username, String password);
  Future<List<Lead>> listLeads(String model, List<dynamic> domain);
  Future<Lead> listLead(String model, int id);
  Future<CreateResponse> createLead(String model, Map<String, dynamic> values);
  Future<UnlinkResponse> unlinkLead(String model, int id);
  Future<WriteResponse> updateLead(String model, int id, Lead values);
  Future<List<dynamic>> getAllForModel(String modelName, List<String> fields);
  Future<int> getIdByName(String modelName, String name);
  Future<String> getNameById(String modelName, int id);
  Future<List<String>> getAll(String modelName);
  Future<List<String>> getNamesByIds(String modelName, List<int>? ids);
  Future<List<String>> getAllNames(String modelName);
}

abstract class OdooDataSource {
  Future<Map<String, dynamic>> authenticate(String url, String username, String password);
  Future<List<Map<String, dynamic>>> searchRead(String model, List<dynamic> domain);
  Future<Map<String, dynamic>> read(String model, int id);
  Future<bool> unlink(String model, int id);
  Future<bool> write(String model, int id, Lead values);
  Future<Map<String, dynamic>> create(String model, Map<String, dynamic> values);
}