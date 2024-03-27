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
  final String? contactName;
  final String? phone;
  final String? email;
  final int? companyId;
  final int? userId;
  final String? dateDeadline;
  final int? teamId;
  final int? expectedRevenue;
  final List<int>? tagIds;
  final String? priority;
  final String? probability;
  final String? createDate;
  final int? stageId;

  CrmLead({
    required this.id,
    required this.name,
    this.contactName,
    this.phone,
    this.email,
    this.companyId,
    this.userId,
    this.dateDeadline,
    this.teamId,
    this.expectedRevenue,
    this.tagIds,
    this.priority,
    this.probability,
    this.createDate,
    this.stageId,
  });

  static dynamic parseStringField(dynamic value) {
    return (value is bool && !value) ? null : value as String?;
  }

  static int? parseIntField(dynamic value) {
    if (value is double) {
      return value.toInt();
    } else if (value is bool) {
      return null;
    } else {
      return value[0] as int?;
    }
  }

  factory CrmLead.fromJson(Map<String, dynamic> json) {

    final List<dynamic>? tagsJson = json['tag_ids'];
    List<int>? tagIds;
    if (tagsJson != null) {
      tagIds = tagsJson.map<int>((dynamic id) => id as int).toList();
    }
    final List<dynamic>? stagesJson = json['stage_id'];
    int? stagesIds;
    if (stagesJson != null) {
      stagesIds = stagesJson.first as int;
    }

    return CrmLead(
      id: json['id'],
      name: json['name'],
      contactName: parseStringField(json['contact_name']),
      phone: parseStringField(json['phone']),
      email: parseStringField(json['email_from']),
      companyId: parseIntField(json['company_id']),
      userId: parseIntField(json['user_id']),
      dateDeadline: parseStringField(json['date_deadline']),
      teamId: parseIntField(json['team_id']),
      expectedRevenue: (json['expected_revenue'] != null) ? parseIntField(json['expected_revenue']) : null,
      tagIds: tagIds,
      priority: parseStringField(json['priority']),
      probability: double.parse(json['probability'].toString()).toStringAsFixed(2),
      createDate: parseStringField(json['create_date']),
      stageId: stagesIds,
    );

  }

  @override
  String toString() {
    return 'Id: $id - Nombre: $name - Contacto: $contactName - Email: $email - Teléfono: $phone - Compañía: $companyId - Fecha límite: $dateDeadline - Sales Team: $teamId - Expected Income: $expectedRevenue - Tags: $tagIds - Priority: $priority - Probability: $probability - Fecha de Creación: $createDate - Etapa: $stageId';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (name != null) data['name'] = name;
    if (contactName != null) data['contact_name'] = contactName;
    if (phone != null) data['phone'] = phone;
    if (email != null) data['email'] = email;
    if (companyId != null) data['company_id'] = companyId;
    if (userId != null) data['user_id'] = userId;
    if (dateDeadline != null) data['date_deadline'] = dateDeadline;
    if (teamId != null) data['team_id'] = teamId;
    if (expectedRevenue != null) data['expected_revenue'] = expectedRevenue;
    if (tagIds != null) data['tag_ids'] = tagIds;
    if (priority != null) data['priority'] = priority;
    if (probability != null) data['probability'] = probability;
    if (createDate != null) data['create_date'] = createDate;
    if (stageId != null) data['stage_id'] = stageId;
    return data;
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