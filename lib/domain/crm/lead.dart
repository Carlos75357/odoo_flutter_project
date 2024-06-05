import '../parse_types.dart';

/// [Lead] model class, contains the data of a lead
class Lead {
  int id;
  String? name;
  int? clientId;
  String? phone;
  String? email;
  int? companyId;
  int? userId;
  String? dateDeadline;
  int? teamId;
  double? expectedRevenue;
  List<int>? tagIds;
  String? priority;
  double? probability;
  String? createDate;
  int? stageId;

  Lead({
    required this.id,
    required this.name,
    this.clientId,
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

  /// Convert a [Map] into a [Lead]
  factory Lead.fromJson(Map<String, dynamic> json) {

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

    return Lead(
      id: json['id'],
      name: parseStringField(json['name']),
      clientId: parseIntField(json['partner_id']),
      phone: parseStringField(json['phone']),
      email: parseStringField(json['email_from']),
      companyId: parseIntField(json['company_id']),
      userId: parseIntField(json['user_id']),
      dateDeadline: parseStringField(json['date_deadline']),
      teamId: parseIntField(json['team_id']),
      expectedRevenue: parseDoubleField(json['expected_revenue']),
      tagIds: tagIds,
      priority: parseStringField(json['priority']),
      probability: parseDoubleField(json['probability']),
      createDate: parseStringField(json['create_date']),
      stageId: stagesIds,
    );

  }

  @override
  String toString() {
    return 'Id: $id - Nombre: $name - Contacto: $clientId - Email: $email - Teléfono: $phone - Cliente: $clientId - Compañía: $companyId - Usuario: $userId - Fecha límite: $dateDeadline - Sales Team: $teamId - Expected Income: $expectedRevenue - Tags: $tagIds - Priority: $priority - Probability: $probability - Fecha de Creación: $createDate - Etapa: $stageId';
  }

  /// Convert a [Lead] into a [Map]
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (name != null) data['name'] = name;
    if (clientId != null) data['partner_id'] = clientId;
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