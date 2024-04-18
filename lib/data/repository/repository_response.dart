/// Response class representing the outcome of a login attempt.
///
/// This class encapsulates the result of a login attempt, indicating whether
/// the attempt was successful and providing an optional error message in case
/// of failure.
class LoginResponse {
  /// Indicates whether the login attempt was successful.
  final bool success;

  /// Optional error message in case of failure.
  final String? errorMessage;

  /// Constructs a [LoginResponse] instance with the given success status and error message.
  LoginResponse({
    required this.success,
    this.errorMessage,
  });

  /// Factory method to construct a [LoginResponse] object from a JSON map.
  ///
  /// If the JSON map contains an 'error' key, the login attempt is considered unsuccessful
  /// and the error message is extracted from the map. Otherwise, the login attempt is considered
  /// successful with no error message.
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
/// Response class representing the outcome of an unlink operation.
///
/// This class encapsulates the result of an unlink operation, indicating whether
/// records were successfully unlinked.
class UnlinkResponse {
  /// Indicates whether records were successfully unlinked.
  final bool records;

  /// Constructs a [UnlinkResponse] instance with the given [records] status.
  UnlinkResponse(this.records);

  /// Factory method to construct a [UnlinkResponse] object from a JSON boolean value.
  ///
  /// The boolean value indicates whether records were successfully unlinked.
  factory UnlinkResponse.fromJson(bool json) {
    return UnlinkResponse(json);
  }
}


/// Response class representing the outcome of a write operation.
///
/// This class handles the response from a write operation. If the operation is successful,
/// [success] will be `true` and [id] will contain the ID of the written record. If there
/// is an error, [success] will be `false` and [id] will be `null`.
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
