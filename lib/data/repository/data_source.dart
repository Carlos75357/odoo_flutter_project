import '../../domain/crm/lead.dart';
import '../../domain/project/project.dart';
import '../../domain/Task/task.dart';
import 'crm/crm_repository_response.dart';

abstract class RepositoryDataSource {
  Future<LoginResponse> login(String url, String username, String password, String db);

  Future<List<Lead>> listLeads(String model, List<dynamic> domain, Map<String, dynamic> kwargs);

  Future<Lead> listLead(String model, int id);

  Future<CreateResponse> createLead(String model, Map<String, dynamic> values);

  Future<UnlinkResponse> unlinkLead(String model, int id);

  Future<WriteResponse> updateLead(String model, int id, Lead values);

  Future<List<Map<String, dynamic>>> getAllForModel(String modelName, List<String> fields);

  Future<int> getIdByName(String modelName, String name);

  Future<List<int>> getIdsByNames(String modelName, List<String> name);

  Future<String> getNameById(String modelName, int id);

  Future<List<String>> getNamesByIds(String modelName, List<int>? ids);

  Future<List<String>> getAllNames(String modelName, List<String> fields);
}

abstract class ProjectRepositoryDataSource {
  // listProject, listProjects, createProject, updateProject, unlinkProject, getIdByName, gerIdsByName, getNameById, getNamesByIds, getAllNames
  Future<List<Project>> listProjects(String modelName, List<dynamic> domain, Map<String, dynamic> kwargs);
  Future<Project> listProject(String modelName, int id);
  Future<CreateResponse> createProject(String model, Map<String, dynamic> values);
  Future<WriteResponse> updateProject(String model, int id, Project values);
  Future<UnlinkResponse> unlinkProject(String model, int id);
  Future<int> getIdByName(String modelName, String name);
  Future<List<int>> getIdsByName(String modelName, List<String> names);
  Future<String> getNameById(String modelName, int id);
  Future<List<String>> getNamesByIds(String modelName, List<int>? ids);
  Future<List<String>> getAllNames(String modelName, List<String> fields);
  Future<Map<String, dynamic>> getAll(String modelName, List<String> fields, List<dynamic> domain);
}

abstract class TaskRepositoryDataSource {
  Future<List<Task>> listTasks(String modelName, List<dynamic> domain, Map<String, dynamic> kwargs);
  Future<Task> listTask(String modelName, int id);
  Future<CreateResponse> createTask(String model, Map<String, dynamic> values);
  Future<WriteResponse> updateTask(String model, int id, Task values);
  Future<UnlinkResponse> unlinkTask(String model, int id);
  Future<int> getIdByName(String modelName, String name);
  Future<List<int>> getIdsByName(String modelName, List<String> names);
  Future<String> getNameById(String modelName, int id);
  Future<List<String>> getNamesByIds(String modelName, List<int>? ids);
  Future<List<String>> getAllNames(String modelName, List<String> fields);
  Future<Map<String, dynamic>> getAll(String modelName, List<String> fields, List<dynamic> domain);
}

abstract class OdooDataSource {
  Future<Map<String, dynamic>> authenticate(String url, String username, String password, String db);

  Future<List<Map<String, dynamic>>> searchRead(String model, List<dynamic> domain, Map<String, dynamic> kwargs);

  Future<Map<String, dynamic>> read(String model, int id, Map<String, dynamic> kwargs);

  Future<bool> unlink(String model, int id);

  Future<bool> write(String model, int id, Lead values);

  Future<Map<String, dynamic>> create(String model, Map<String, dynamic> values);
}
