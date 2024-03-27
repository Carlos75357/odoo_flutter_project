class OdooConfig {
  static String baseUrl = '';
  static String sessionId = '';

  static String getBaseUrl() {
    return baseUrl;
  }
  static void setBaseUrl(String url) {
    baseUrl = url;
  }

  static String getSessionId() {
    return sessionId;
  }

  static void setSessionId(String id) {
    sessionId = id;
  }
}