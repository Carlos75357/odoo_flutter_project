class Project {
  final int id;
  final String? name;
  final int? partner_id;
  final int? company_id;
  final int? user_id; // responsable del proyecto
  final List<int>? tag_ids;
  final dynamic? status; // last_update_status, no se como llega de momento
  final DateTime? createDate;
  final DateTime? dateDeadline;
  final int? stage_id;

  Project({
    required this.id,
    this.name,
    this.partner_id,
    this.company_id,
    this.user_id,
    this.tag_ids,
    this.status,
    this.createDate,
    this.dateDeadline,
    this.stage_id
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      partner_id: json['partner_id'],
      company_id: json['company_id'],
      user_id: json['user_id'],
      tag_ids: json['tag_ids'],
      status: json['status'],
      createDate: json['create_date'],
      dateDeadline: json['date_deadline'],
      stage_id: json['stage_id']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (name != null) data['name'] = name;
    if (partner_id != null) data['partner_id'] = partner_id;
    if (company_id != null) data['company_id'] = company_id;
    if (user_id != null) data['user_id'] = user_id;
    if (tag_ids != null) data['tag_ids'] = tag_ids;
    if (status != null) data['status'] = status;
    if (createDate != null) data['create_date'] = createDate;
    if (dateDeadline != null) data['date_deadline'] = dateDeadline;
    if (stage_id != null) data['stage_id'] = stage_id;
    return data;
  }

  @override
  String toString() {
    return 'Id: $id - Nombre: $name - Responsable: $user_id - Etapa: $stage_id';
  }
}