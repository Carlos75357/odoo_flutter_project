import 'package:flutter_crm_prove/domain/project/project.dart';

class ProjectFormated {
  int id;
  String? name;
  String? taskName;
  int? partnerId;
  String? partnerName;
  List<int>? typeIds; // type_ids
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
  List<int>? tasksStageId;
  // String? createdUser;

  ProjectFormated({
    required this.id,
    this.name,
    this.taskName,
    this.partnerId,
    this.partnerName,
    this.typeIds,
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
    this.tasksStageId,
    // this.createdUser,
  });

  Project projectFormatedToProject(ProjectFormated projectFormated) {
    return Project(
        id: projectFormated.id,
        name: projectFormated.name,
        taskName: projectFormated.taskName,
        partnerId: projectFormated.partnerId,
        typeIds: projectFormated.typeIds,
        companyId: projectFormated.companyId,
        userId: projectFormated.userId,
        tagIds: projectFormated.tagIds,
        status: projectFormated.status,
        stageId: projectFormated.stageId,
        dateStart: projectFormated.dateStart,
        date: projectFormated.date,
        tasks: projectFormated.tasks,
        tasksStageId: projectFormated.tasksStageId
    );
  }

  factory ProjectFormated.fromJson(Map<String, dynamic> json) {
    return ProjectFormated(
      id: json['id'] ?? 0,
      name: json['name'],
      taskName: json['task_name'],
      partnerId: json['partner_id'],
      partnerName: json['partner_name'],
      typeIds: json['type_ids'],
      companyId: json['company_id'],
      companyName: json['company_name'],
      userId: json['user_id'],
      userName: json['user_name'],
      tagIds: json['tag_ids'],
      tagNames: json['tag_names'],
      status: json['last_update_status'],
      stageId: json['stage_id'],
      stageName: json['stage_name'],
      dateStart: json['create_date'],
      date: json['date_deadline'],
      tasks: json['tasks'],
      tasksStageId: json['stages_id'],
      // createdUser: json['created_user'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (name != null) data['name'] = name;
    if (taskName != null) data['task_name'] = taskName;
    if (partnerId != null) data['partner_id'] = partnerId;
    if (partnerName != null) data['partner_name'] = partnerName;
    if (typeIds != null) data['type_ids'] = typeIds;
    if (companyId != null) data['company_id'] = companyId;
    if (companyName != null) data['company_name'] = companyName;
    if (userId != null) data['user_id'] = userId;
    if (userName != null) data['user_name'] = userName;
    if (tagIds != null) data['tag_ids'] = tagIds;
    if (tagNames != null) data['tag_names'] = tagNames;
    if (status != null) data['last_update_status'] = status;
    if (stageId != null) data['stage_id'] = stageId;
    if (stageName != null) data['stage_name'] = stageName;
    if (dateStart != null) data['create_date'] = dateStart;
    if (date != null) data['date_deadline'] = date;
    if (tasks != null) data['tasks'] = tasks;
    if (tasksStageId != null) data['tasks_stage_id'] = tasksStageId;

    return data;
  }
}