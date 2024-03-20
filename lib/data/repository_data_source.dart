abstract class RepositoryDataSource {
  // TODO DECLARAR AUTHENTICATE, SEARCH_READ, READ, WRITE, UNLINK
  Future<LoginResponse> authenticate(String url, String db, String username, String password);
  Future<SearchResponse> searchRead(String model, List<dynamic> domain);
  Future<ReadResponse> read(String model, List<int> id);
  Future<UnlinkResponse> unlink(String model, List<int> ids);
  Future<WriteResponse> write(String model, List<int> ids, Map<String, dynamic> values);
  Future<CreateResponse> create(String model, Map<String, dynamic> values);
}

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

class UnlinkResponse {
  final List<dynamic> records;
  UnlinkResponse(this.records);

  factory UnlinkResponse.fromJson(List<dynamic> json) {
    return UnlinkResponse(json);
  }
}

class WriteResponse {
  final bool success;
  final bool? id;

  WriteResponse({required this.success, this.id});

  factory WriteResponse.fromJson(Map<String, dynamic> json) {
    return WriteResponse(
      success: true,
      id: json['result'],
    );
  }
}


class CreateResponse {
  final bool success;
  final int id;

  CreateResponse({required this.success, required this.id});

  factory CreateResponse.fromJson(Map<String, dynamic> json) {
    int id = json['result'];
    return CreateResponse(
      success: id > 0,
      id: id,
    );
  }
}
