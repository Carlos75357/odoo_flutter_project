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

/// Class UnlinkResponse to handle response from unlink
class UnlinkResponse {
  final bool records;
  UnlinkResponse(this.records);

  factory UnlinkResponse.fromJson(bool json) {
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

  CreateResponse({required this.success, this.id});

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