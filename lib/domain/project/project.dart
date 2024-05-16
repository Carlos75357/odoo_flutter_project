class Project {
  final int id;
  final String? name;
  final int? partnerId;
  final int? companyId;
  final int? userId; // responsable del proyecto
  final List<int>? tagIds;
  final dynamic status; // last_update_status, no se como llega de momento
  final DateTime? createDate;
  final DateTime? dateDeadline;
  final int? stageId;

  Project({
    required this.id,
    this.name,
    this.partnerId,
    this.companyId,
    this.userId,
    this.tagIds,
    this.status,
    this.createDate,
    this.dateDeadline,
    this.stageId
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      partnerId: json['partner_id'],
      companyId: json['company_id'],
      userId: json['user_id'],
      tagIds: json['tag_ids'],
      status: json['status'],
      createDate: json['create_date'],
      dateDeadline: json['date_deadline'],
      stageId: json['stage_id']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (name != null) data['name'] = name;
    if (partnerId != null) data['partner_id'] = partnerId;
    if (companyId != null) data['company_id'] = companyId;
    if (userId != null) data['user_id'] = userId;
    if (tagIds != null) data['tag_ids'] = tagIds;
    if (status != null) data['status'] = status;
    if (createDate != null) data['create_date'] = createDate;
    if (dateDeadline != null) data['date_deadline'] = dateDeadline;
    if (stageId != null) data['stage_id'] = stageId;
    return data;
  }

  @override
  String toString() {
    return 'Id: $id - Nombre: $name - Responsable: $userId - Etapa: $stageId';
  }
}