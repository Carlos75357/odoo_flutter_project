/// The [JsonRequest] class represents a JSON-RPC request.
class JsonRequest {
  /// The version of the JSON-RPC protocol. Always '2.0' for this implementation.
  var jsonrpc;

  /// The name of the method to be invoked. Always 'call' for this implementation.
  var method;

  /// The parameters of the method to be invoked.
  var params;

  /// Constructs a [JsonRequest] with the given [map] as parameters.
  JsonRequest(Map map) {
    jsonrpc = "2.0";
    method = 'call';
    params = map;
  }

  /// Constructs a [JsonRequest] from a map [json].
  /// The 'result' field of the map is used as parameters for the request.
  factory JsonRequest.fromJson(Map<String, dynamic> json) {
    return JsonRequest(json['result']);
  }

  /// Converts this [JsonRequest] to a map that can be serialized to JSON.
  Map<String, dynamic> toJson() {
    return {
      'jsonrpc': jsonrpc,
      'method': method,
      'params': params,
    };
  }
}