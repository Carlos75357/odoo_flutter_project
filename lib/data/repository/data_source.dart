import '../../domain/lead.dart';
import 'repository_response.dart';

/// [RepositoryDataSource] is an abstract class that defines the contract for a data source.
/// It includes methods for logging in, listing leads, creating, updating, and deleting leads,
/// and methods for retrieving model data by name or ID.
abstract class RepositoryDataSource {
  /// Logs in to the data source with the given [url], [username], and [password].
  Future<LoginResponse> login(String url, String username, String password);

  /// Lists all leads for the given [model] and [domain].
  Future<List<Lead>> listLeads(String model, List<dynamic> domain);

  /// Lists a single lead with the given [model] and [id].
  Future<Lead> listLead(String model, int id);

  /// Creates a new lead with the given [model] and [values].
  Future<CreateResponse> createLead(String model, Map<String, dynamic> values);

  /// Deletes the lead with the given [model] and [id].
  Future<UnlinkResponse> unlinkLead(String model, int id);

  /// Updates the lead with the given [model], [id], and [values].
  Future<WriteResponse> updateLead(String model, int id, Lead values);

  /// Retrieves all data for the given [modelName] and [fields].
  Future<List<Map<String, dynamic>>> getAllForModel(String modelName, List<String> fields);

  /// Retrieves the ID for the given [modelName] and [name].
  Future<int> getIdByName(String modelName, String name);

  /// Retrieves the IDs for the given [modelName] and [name].
  Future<List<int>> getIdsByNames(String modelName, List<String> name);

  /// Retrieves the name for the given [modelName] and [id].
  Future<String> getNameById(String modelName, int id);

  /// Retrieves all data for the given [modelName].
  Future<List<String>> getAll(String modelName);

  /// Retrieves the names for the given [modelName] and [ids].
  Future<List<String>> getNamesByIds(String modelName, List<int>? ids);

  /// Retrieves all names for the given [modelName].
  Future<List<String>> getAllNames(String modelName);
}

/// [OdooDataSource] is an abstract class that defines the contract for an Odoo data source.
/// It includes methods for authenticating, reading, creating, updating, and deleting data.
abstract class OdooDataSource {
  /// Authenticates with the given [url], [username], and [password].
  Future<Map<String, dynamic>> authenticate(String url, String username, String password);

  /// Performs a search-read operation with the given [model] and [domain].
  Future<List<Map<String, dynamic>>> searchRead(String model, List<dynamic> domain);

  /// Reads the data with the given [model] and [id].
  Future<Map<String, dynamic>> read(String model, int id);

  /// Deletes the data with the given [model] and [id].
  Future<bool> unlink(String model, int id);

  /// Updates the data with the given [model], [id], and [values].
  Future<bool> write(String model, int id, Lead values);

  /// Creates new data with the given [model] and [values].
  Future<Map<String, dynamic>> create(String model, Map<String, dynamic> values);
}
