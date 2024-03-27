class JsonRequest {
  var jsonrpc;
  var method;
  var params;

  JsonRequest(Map map) {
    jsonrpc = "2.0";
    method = 'call';
    params = map;
  }

  factory JsonRequest.fromJson(Map<String, dynamic> json) {
    return JsonRequest(json['result']);
  }

  Map<String, dynamic> toJson() {
    return {
      'jsonrpc': jsonrpc,
      'method': method,
      'params': params,
    };
  }
}