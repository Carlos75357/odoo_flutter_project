/// Utility class for managing configuration settings related to Odoo.
///
/// This class provides static methods and properties for managing the base URL
/// and session ID used for communication with an Odoo server.
class OdooConfig {
  /// The base URL of the Odoo server.
  static String baseUrl = '';

  /// The session ID obtained after successful authentication with the Odoo server.
  static String sessionId = '';
  static String database = '';

  /// Returns the current base URL configured for communication with the Odoo server.
  static String getBaseUrl() {
    return baseUrl;
  }

  /// Sets the base URL for communication with the Odoo server.
  static void setBaseUrl(String url) {
    baseUrl = url;
  }

  /// Returns the current session ID obtained after successful authentication.
  static String getSessionId() {
    return sessionId;
  }

  /// Sets the session ID obtained after successful authentication.
  static void setSessionId(String id) {
    sessionId = id;
  }

  static void setDb(String db) {
    database = db;
  }
}
