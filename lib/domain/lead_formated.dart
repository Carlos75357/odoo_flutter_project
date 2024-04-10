import 'lead.dart';

class LeadFormated {
  int id;
  String? name;
  String? email;
  String? phone;
  String? client;
  int? clientId;
  String? company;
  int? companyId;
  String? stage;
  int? stageId;
  String? user;
  int? userId;
  List<String>? tags;
  List<int>? tagsId;
  String? dateDeadline;
  int? expectedRevenue;
  String? probability;
  int? priority;


  LeadFormated({required this.id, this.name, this.email, this.phone, this.client,
      this.clientId, this.company, this.companyId, this.stage, this.stageId,
      this.user, this.userId, this.tags, this.tagsId, this.dateDeadline,
      this.expectedRevenue, this.probability, this.priority});

  static dynamic parseStringField(dynamic value) {
    return (value is bool) ? null : value as String?;
  }

  static int? parseIntField(dynamic value) {
    if (value is double) {
      return value.toInt();
    } else if (value is bool) {
      return null;
    } else if (value is int) {
      return value;
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return 'Id: $id - Nombre: $name - Email: $email - Teléfono: $phone - Cliente: $client - ID de Cliente: $clientId - Compañía: $company - ID de Compañía: $companyId - Etapa: $stage - ID de Etapa: $stageId - Usuario: $user - ID de Usuario: $userId - Etiquetas: $tags - IDs de Etiquetas: $tagsId - Fecha Límite: $dateDeadline - Ingreso Esperado: $expectedRevenue - Probabilidad: $probability';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (client != null) data['client'] = client;
    if (clientId != null) data['client_id'] = clientId;
    if (company != null) data['company'] = company;
    if (companyId != null) data['company_id'] = companyId;
    if (stage != null) data['stage'] = stage;
    if (stageId != null) data['stage_id'] = stageId;
    if (user != null) data['user'] = user;
    if (userId != null) data['user_id'] = userId;
    if (tags != null) data['tags'] = tags;
    if (priority != null) data['priority'] = priority;
    if (tagsId != null) data['tags_id'] = tagsId;
    if (dateDeadline != null) data['date_deadline'] = dateDeadline;
    if (expectedRevenue != null) data['expected_revenue'] = expectedRevenue;
    if (probability != null) data['probability'] = probability;

    return data;
  }

  Lead leadFormatedToLead(LeadFormated leadFormated) {
    return Lead(
      id: leadFormated.id,
      name: leadFormated.name,
      email: leadFormated.email,
      phone: leadFormated.phone,
      clientId: leadFormated.clientId,
      companyId: leadFormated.companyId,
      stageId: leadFormated.stageId,
      userId: leadFormated.userId,
      dateDeadline: leadFormated.dateDeadline,
      expectedRevenue: leadFormated.expectedRevenue,
      probability: leadFormated.probability,
      tagIds: leadFormated.tagsId,
      priority: leadFormated.priority?.toString(),
    );
  }

  factory LeadFormated.fromJson(Map<String, dynamic> json) {
    print(json);
    return LeadFormated(
      id: json['id'],
      name: json['name'],
      email: parseStringField(json['email']),
      phone: parseStringField(json['phone']),
      client: parseStringField(json['client']),
      // clientId: parseIntField(json['client_id']),
      company: parseStringField(json['company']),
      // companyId: parseIntField(json['company_id']),
      stage: parseStringField(json['stage']),
      // stageId: parseIntField(json['stage_id']),
      user: parseStringField(json['user']),
      // userId: parseIntField(json['user_id']),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      // tagsId: json['tags_id'] != null ? List<int>.from(json['tags_id']) : null,
      dateDeadline: parseStringField(json['date_deadline']),
      expectedRevenue: parseIntField(json['expected_revenue']),
      priority: parseIntField(json['priority']),
      probability: parseStringField(json['probability']),
    );
  }
}