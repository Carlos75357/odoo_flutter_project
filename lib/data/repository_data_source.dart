abstract class RepositoryDataSource {
  // TODO DECLARAR AUTHENTICATE, SEARCH_READ, READ, WRITE, UNLINK
  Future<LoginResponse> authenticate(String url, String db, String username, String password);
  Future<SearchResponse> searchRead(String model, List<dynamic> domain);
  Future<ReadResponse> read(String model, List<int> id);
  Future<UnlinkResponse> unlink(String model, List<int> ids);
  Future<WriteResponse> write(String model, List<int> ids, Map<String, dynamic> values);
  Future<CreateResponse> create(String model, Map<String, dynamic> values);
}

/// Class LoginResponse to handle response from authenticate, if there is an
/// error, the bool success will be false.
class LoginResponse {
  final bool success;
  final String? errorMessage;

  LoginResponse({
    required this.success,
    this.errorMessage,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error')) {
      return LoginResponse(
        success: false,
        errorMessage: json['error']['message'],
      );
    } else {
      return LoginResponse(
        success: true,
      );
    }
  }
}


/// Class SearchResponse to handle response from searchRead
class SearchResponse {
  final List<dynamic> records;
  SearchResponse(this.records);

  factory SearchResponse.fromJson(List<dynamic> json) {
    return SearchResponse(json);
  }
}

/// Class ReadResponse to handle response from read
class ReadResponse {
  final List<dynamic> records;
  ReadResponse(this.records);

  factory ReadResponse.fromJson(List<dynamic> json) {
    return ReadResponse(json);
  }
}

/// Class UnlinkResponse to handle response from unlink
class UnlinkResponse {
  final List<dynamic> records;
  UnlinkResponse(this.records);

  factory UnlinkResponse.fromJson(List<dynamic> json) {
    return UnlinkResponse(json);
  }
}

/// Class WriteResponse to handle response from write, if there is an error,
/// the bool success will be false and the int id will be null.
class WriteResponse {
  final bool success;
  final bool? id;

  WriteResponse({required this.success, this.id});

  factory WriteResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error')) {
      return WriteResponse(
        success: false,
        id: null,
      );
    } else {
      return WriteResponse(
        success: true,
        id: json['result'],
      );
    }
  }
}

/// Class CreateResponse to handle response from create, if there is an error,
/// the bool success will be false and the int id will be null.
class CreateResponse {
  final bool success;
  final int? id;

  CreateResponse({required this.success, required this.id});

  factory CreateResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('error')) {
      return CreateResponse(
        success: false,
        id: null,
      );
    } else {
      return CreateResponse(
        success: true,
        id: json['result'],
      );
    }
  }
}
