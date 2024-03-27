import '../../domain/lead.dart';
import 'repository_response.dart';

abstract class RepositoryDataSource {
  // changeName, updateEmail, updatePhone, updateCompany, updateDateLimit,
  // updateSalesTeam, updateExpectedIncome, updateTagIds, updatePriority,
  // updateProbability, updateDateCreate, updateStage.
  Future<LoginResponse> login(String url, String username, String password);
  Future<List<Lead>> listLeads(String model, List<dynamic> domain);
  Future<Lead> listLead(String model, int id);
  Future<CreateResponse> createLead(String model, Map<String, dynamic> values);
  Future<UnlinkResponse> unlinkLead(String model, int id);
  Future<List<String>> tagNames(List<dynamic>? tagIds);
  Future<String> stageNameById(int stageIds);
  Future<int> stageIdByName(String stageName);
  Future<List<String>> stageNames();
}

abstract class OdooDataSource {
  Future<Map<String, dynamic>> authenticate(String url, String username, String password);
  Future<List<Map<String, dynamic>>> searchRead(String model, List<dynamic> domain);
  Future<Map<String, dynamic>> read(String model, int id);
  Future<bool> unlink(String model, int id);
  Future<bool> write(String model, int id, Lead values);
  Future<Map<String, dynamic>> create(String model, Map<String, dynamic> values);
}