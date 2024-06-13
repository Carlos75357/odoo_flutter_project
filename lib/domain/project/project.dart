import 'package:flutter_crm_prove/domain/parse_types.dart';

class Project {
  int id;
  String? name;
  String? taskName;
  int? partnerId;
  List<int>? typeIds; // type_ids
  int? companyId;
  int? userId; // responsable del proyecto
  List<int>? tagIds;
  String? status; // last_update_status, no se como llega de momento
  int? stageId;
  String? dateStart;
  String? date;
  // final int? objectives;
  // final int? objectivesDone;
  List<int>? tasks;
  List<int>? tasksStageId;
  // final String? createdUser;

  Project({
    required this.id,
    this.name,
    this.taskName,
    this.partnerId,
    this.typeIds,
    this.companyId,
    this.userId,
    this.tagIds,
    this.status,
    this.stageId,
    this.dateStart,
    this.date,
    // this.objectives,
    // this.objectivesDone,
    this.tasks,
    this.tasksStageId,
    // this.createdUser
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

    final List<dynamic>? typeIdsJson = json['type_ids'];
    List<int>? typeIds;
    if (typeIdsJson != null) {
      typeIds = typeIdsJson.map<int>((dynamic id) => id as int).toList();
    }

    final List<dynamic>? tasksStageIdJson = json['stages_id'];
    List<int>? tasksStageId;
    if (tasksStageIdJson != null) {
      tasksStageId = tasksStageIdJson.map<int>((dynamic id) => id as int).toList();
    }
    
    return Project(
      id: json['id'] ?? 0,
      name: parseStringField(json['name']),
      taskName: parseStringField(json['label_tasks']),
      partnerId: parseListToInt(json['partner_id']),
      typeIds: typeIds,
      companyId: parseListToInt(json['company_id']),
      userId: parseListToInt(json['user_id']),
      tagIds: tagIds,
      status: parseStringField(json['last_update_status']),
      stageId: parseListToInt(json['stage_id']),
      dateStart: parseStringField(json['date_start']),
      date: parseStringField(json['date']),
      tasks: tasks,
      tasksStageId: tasksStageId,
      // objectives: parseIntField(json['objectives']),
      // objectivesDone: parseIntField(json['objectives_done']),
      // createdUser: parseStringField(json['create_uid']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (name != null) data['name'] = name;
    if (partnerId != null) data['partner_id'] = partnerId;
    if (typeIds != null) data['type_ids'] = typeIds;
    if (companyId != null) data['company_id'] = companyId;
    if (userId != null) data['user_id'] = userId;
    if (tagIds != null) data['tag_ids'] = tagIds;
    if (status != null) data['status'] = status;
    if (stageId != null) data['stage_id'] = stageId;
    if (dateStart != null) data['create_date'] = dateStart;
    if (date != null) data['date_deadline'] = date;
    // if (objectives != null) data['objectives'] = objectives;
    // if (objectivesDone != null) data['objectives_done'] = objectivesDone;
    if (tasks != null) data['tasks'] = tasks;
    // if (tasksStageId != null) data['stages_id'] = tasksStageId;
    // if (createdUser != null) data['created_user'] = createdUser;
    return data;
  }

  @override
  String toString() {
    return 'Id: $id - Nombre: $name - Responsable: $userId';
  }
}