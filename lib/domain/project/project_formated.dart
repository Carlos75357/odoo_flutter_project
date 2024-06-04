import 'package:flutter_crm_prove/domain/project/project.dart';

class ProjectFormated {
  int id;
  String? name;
  String? taskName;
  int? partnerId;
  String? partnerName;
  int? companyId;
  String? companyName;
  int? userId;
  String? userName; // responsable del proyecto
  List<int>? tagIds;
  List<String>? tagNames;
  String? status; // last_update_status, no se como llega de momento
  int? stageId;
  String? stageName;
  String? dateStart;
  String? date;
  List<int>? tasks;
  // String? createdUser;

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
    this.stageId,
    this.stageName,
    this.dateStart,
    this.date,
    this.tasks,
    // this.createdUser,
  });

  Project projectFormatedToProject(ProjectFormated projectFormated) {
    return Project(
        id: projectFormated.id,
        name: projectFormated.name,
        taskName: projectFormated.taskName,
        partnerId: projectFormated.partnerId,
        companyId: projectFormated.companyId,
        userId: projectFormated.userId,
        tagIds: projectFormated.tagIds,
        status: projectFormated.status,
        stageId: projectFormated.stageId,
        dateStart: projectFormated.dateStart,
        date: projectFormated.date,
        tasks: projectFormated.tasks,
    );
  }

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
      stageId: json['stage_id'],
      stageName: json['stage_name'],
      dateStart: json['create_date'],
      date: json['date_deadline'],
      tasks: json['tasks'],
      // createdUser: json['created_user'],
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
    data['stage_id'] = stageId;
    data['stage_name'] = stageName;
    data['create_date'] = dateStart;
    data['date_deadline'] = date;
    data['tasks'] = tasks;
    // data['created_user'] = createdUser;
    return data;
  }
}