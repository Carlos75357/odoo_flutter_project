abstract class RepositoryDataSource {
  // TODO DECLARAR AUTHENTICATE, SEARCH_READ, READ, WRITE, UNLINK
  Future<LoginResponse> authenticate(String url, String db, String username, String password);
  Future<SearchResponse> searchRead(String? sessionId, String model, List<dynamic> domain);
  Future<ReadResponse> read(String model, List<int> ids);
  // Future<WriteResponse> write(String model, List<int> ids, Map<String, dynamic> values);
  // Future<UnlinkResponse> unlink(String model, List<int> ids);
}

class LoginResponse {
  final int uid;
  final bool isAdmin;
  final String db;
  final String name;
  final String username;

  LoginResponse({
    required this.uid,
    required this.isAdmin,
    required this.db,
    required this.name,
    required this.username,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      uid: json['result']['uid'],
      isAdmin: json['result']['is_admin'],
      db: json['result']['db'],
      name: json['result']['name'],
      username: json['result']['username'],
    );
  }
}

class SearchResponse {
  final List<dynamic> records;
  SearchResponse(this.records);

  factory SearchResponse.fromJson(List<dynamic> json) {
    return SearchResponse(json);
  }
}

class ReadResponse {
  final List<dynamic> records;
  ReadResponse(this.records);

  factory ReadResponse.fromJson(List<dynamic> json) {
    return ReadResponse(json);
  }
}

class WriteResponse {
  final List<dynamic> records;
  WriteResponse(this.records);

  factory WriteResponse.fromJson(List<dynamic> json) {
    return WriteResponse(json);
  }
}

class UnlinkResponse {
  final List<dynamic> records;
  UnlinkResponse(this.records);

  factory UnlinkResponse.fromJson(List<dynamic> json) {
    return UnlinkResponse(json);
  }
}
