class ProjectFormated {
  final int id;
  final String? name;
  final String? taskName;
  final int? partnerId;
  final String? partnerName;
  final int? companyId;
  final String? companyName;
  final int? userId;
  final String? userName; // responsable del proyecto
  final List<int>? tagIds;
  final List<String>? tagNames;
  final dynamic status; // last_update_status, no se como llega de momento
  final String? dateStart;
  final String? date;
  final List<int>? tasks;
  final String? createdUser;

  ProjectFormated({
    required this.id,
    this.name,
    this.taskName,
    this.partnerId,
    this.partnerName,
    this.companyId,
    this.companyName,
    this.userId,
    this.userName,
    this.tagIds,
    this.tagNames,
    this.status,
    this.dateStart,
    this.date,
    this.tasks,
    this.createdUser,
  });

  factory ProjectFormated.fromJson(Map<String, dynamic> json) {
    return ProjectFormated(
      id: json['id'],
      name: json['name'],
      taskName: json['task_name'],
      partnerId: json['partner_id'],
      partnerName: json['partner_name'],
      companyId: json['company_id'],
      companyName: json['company_name'],
      userId: json['user_id'],
      userName: json['user_name'],
      tagIds: json['tag_ids'],
      tagNames: json['tag_names'],
      status: json['status'],
      dateStart: json['create_date'],
      date: json['date_deadline'],
      tasks: json['tasks'],
      createdUser: json['created_user'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['task_name'] = taskName;
    data['partner_id'] = partnerId;
    data['partner_name'] = partnerName;
    data['company_id'] = companyId;
    data['company_name'] = companyName;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['tag_ids'] = tagIds;
    data['tag_names'] = tagNames;
    data['status'] = status;
    data['create_date'] = dateStart;
    data['date_deadline'] = date;
    data['tasks'] = tasks;
    data['created_user'] = createdUser;
    return data;
  }
}