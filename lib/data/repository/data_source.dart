import 'repository_response.dart';

abstract class RepositoryDataSource {
  // tagNames, deleteLead, changeName, updateEmail, updatePhone, {updateCompany, updateDateLimit,
  // updateSalesTeam, updateExpectedIncome, updateTagIds, updatePriority, updateProbability, updateDateCreate, updateStage}, createLead, listLead, listAllLeads
  // login
  Future<LoginResponse> login(String url, String username, String password);
  Future<List<CrmLead>> listLeads(String model, List<dynamic> domain);
  Future<CrmLead> listLead(String model, int id);
  Future<CreateResponse> createLead(String model, Map<String, dynamic> values);
  Future<UnlinkResponse> unlinkLead(String model, int id);
  Future<List<String>> tagNames(List<dynamic>? tagIds);
}

abstract class OdooDataSource {
  Future<Map<String, dynamic>> authenticate(String url, String username, String password);
  Future<List<Map<String, dynamic>>> searchRead(String model, List<dynamic> domain);
  Future<Map<String, dynamic>> read(String model, int id);
  Future<bool> unlink(String model, int id);
  Future<bool> write(String model, int id, CrmLead values);
  Future<Map<String, dynamic>> create(String model, Map<String, dynamic> values);
}