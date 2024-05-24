import 'package:flutter_crm_prove/domain/parse_types.dart';

class Project {
  final int id;
  final String? name;
  final String? partnerId;
  final String? companyId;
  final String? userId; // responsable del proyecto
  final List<int>? tagIds;
  final dynamic status; // last_update_status, no se como llega de momento
  final String? dateStart;
  final String? date;
  // final int? objectives;
  // final int? objectivesDone;
  final List<int>? tasks;
  final String? createdUser;

  Project({
    required this.id,
    this.name,
    this.partnerId,
    this.companyId,
    this.userId,
    this.tagIds,
    this.status,
    this.dateStart,
    this.date,
    // this.objectives,
    // this.objectivesDone,
    this.tasks,
    this.createdUser
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? tagsJson = json['tag_ids'];
    List<int>? tagIds;
    if (tagsJson != null) {
      tagIds = tagsJson.map<int>((dynamic id) => id as int).toList();
    }
    
    final List<dynamic>? tasksJson = json['tasks'];
    List<int>? tasks;
    if (tasksJson != null) {
      tasks = tasksJson.map<int>((dynamic id) => id as int).toList();
    }
    
    return Project(
      id: json['id'] ?? 0,
      name: parseStringField(json['name']),
      partnerId: parseListToString(json['partner_id']),
      companyId: parseListToString(json['company_id']),
      userId: parseListToString(json['user_id']),
      tagIds: tagIds,
      status: parseStringField(json['last_update_status']),
      dateStart: parseStringField(json['date_start']),
      date: parseStringField(json['date']),
      tasks: tasks,
      // objectives: parseIntField(json['objectives']),
      // objectivesDone: parseIntField(json['objectives_done']),
      createdUser: parseStringField(json['created_user']),
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
    if (dateStart != null) data['create_date'] = dateStart;
    if (date != null) data['date_deadline'] = date;
    // if (objectives != null) data['objectives'] = objectives;
    // if (objectivesDone != null) data['objectives_done'] = objectivesDone;
    if (tasks != null) data['tasks'] = tasks;
    if (createdUser != null) data['created_user'] = createdUser;
    return data;
  }

  @override
  String toString() {
    return 'Id: $id - Nombre: $name - Responsable: $userId';
  }
}