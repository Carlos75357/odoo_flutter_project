
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

class UnlinkResponse {
  final bool records;

  UnlinkResponse(this.records);

  factory UnlinkResponse.fromJson(bool json) {
    return UnlinkResponse(json);
  }
}

class WriteResponse {
  /// Indicates whether the write operation was successful.
  final bool success;

  /// The ID of the written record, if the operation was successful.
  final bool? id;

  /// Constructs a [WriteResponse] instance with the given success status and record ID.
  WriteResponse({required this.success, this.id});

  /// Factory method to construct a [WriteResponse] object from a JSON map.
  ///
  /// If the JSON map contains an 'error' key, indicating a failure in the write operation,
  /// the [success] status will be `false` and [id] will be `null`. Otherwise, the operation
  /// is considered successful, [success] will be `true`, and [id] will contain the ID of the
  /// written record.
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


/// Response class representing the outcome of a create operation.
///
/// This class handles the response from a create operation. If the operation is successful,
/// [success] will be `true` and [id] will contain the ID of the newly created record. If there
/// is an error, [success] will be `false` and [id] will be `null`.
class CreateResponse {
  /// Indicates whether the create operation was successful.
  final bool success;

  /// The ID of the newly created record, if the operation was successful.
  final int? id;

  /// Constructs a [CreateResponse] instance with the given success status and record ID.
  CreateResponse({required this.success, this.id});

  /// Factory method to construct a [CreateResponse] object from a JSON map.
  ///
  /// If the JSON map contains an 'error' key, indicating a failure in the create operation,
  /// the [success] status will be `false` and [id] will be `null`. Otherwise, the operation
  /// is considered successful, [success] will be `true`, and [id] will contain the ID of the
  /// newly created record.
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
