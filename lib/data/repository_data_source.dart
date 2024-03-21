abstract class RepositoryDataSource {
  // TODO DECLARAR AUTHENTICATE, SEARCH_READ, READ, WRITE, UNLINK
  Future<LoginResponse> authenticate(String url, String db, String username, String password);
  Future<List<CrmLead>> searchRead(String model, List<dynamic> domain);
  Future<CrmLead> read(String model, int id);
  Future<UnlinkResponse> unlink(String model, int id);
  Future<WriteResponse> write(String model, int id, CrmLead values);
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

class CrmLead {
  final int id;
  final String? name;
  final String? description;
  final String? phone;
  final String? email;
  final String? company;
  final String? commercial;
  final String? date_limit;
  final String? sales_team;
  final String? expected_income;
  final List<int>? tagIds; // Cambiado a List<int> en lugar de int
  final String? priority;
  final String? probability;
  final String? date_create;
  final String? stage;

  CrmLead({
    required this.id,
    required this.name,
    this.description,
    this.phone,
    this.email,
    this.company,
    this.commercial,
    this.date_limit,
    this.sales_team,
    this.expected_income,
    this.tagIds, // Cambiado a List<int>? en lugar de int?
    this.priority,
    this.probability,
    this.date_create,
    this.stage,
  });

  factory CrmLead.fromJson(Map<String, dynamic> json) {
    final phone = json['phone'] is bool && !json['phone'] ? null : json['phone'];
    final List<dynamic>? tagsJson = json['tag_ids'];
    List<int>? tagIds;
    if (tagsJson != null) {
      tagIds = tagsJson.map<int>((dynamic id) => id as int).toList();
    }
    return CrmLead(
      id: json['id'],
      name: json['name'],
      phone: phone,
      email: json['email'],
      company: json['company'],
      commercial: json['commercial'],
      date_limit: json['date_limit'],
      sales_team: json['sales_team'],
      expected_income: json['expected_income'],
      tagIds: tagIds,
      priority: json['priority'],
      probability: double.parse(json['probability'].toString()).toStringAsFixed(2),
      date_create: json['date_create'],
      stage: json['stage'],
    );
  }

  @override
  String toString() {
    return 'Id: $id - Nombre: $name - Email: $email - Teléfono: $phone - Compañia: $company - Fecha límite: $date_limit - Sales Team: $sales_team - Expected Income: $expected_income - Tags: $tagIds - Priority: $priority - Probability: $probability - Date Create: $date_create - Stage: $stage';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (email != null) data['email'] = email;
    if (company != null) data['company'] = company;
    if (commercial != null) data['commercial'] = commercial;
    if (date_limit != null) data['date_limit'] = date_limit;
    if (sales_team != null) data['sales_team'] = sales_team;
    if (expected_income != null) data['expected_income'] = expected_income;
    if (tagIds != null) data['tag_ids'] = tagIds;
    if (priority != null) data['priority'] = priority;
    if (probability != null) data['probability'] = probability;
    if (date_create != null) data['date_create'] = date_create;
    if (stage != null) data['stage'] = stage;
    return data;
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
