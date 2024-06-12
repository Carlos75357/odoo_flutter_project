import 'package:flutter_crm_prove/domain/Task/task.dart';
import 'package:flutter_crm_prove/domain/parse_types.dart';

class TaskFormated {
  int id;
  String? name;
  String? description;
  List<int>? assignedIds; // user_ids
  List<String>? assignedNames;
  int? clientId;
  String? clientName;
  String? dateEnd; // date_end
  List<int>? tagIds;
  List<String>? tagNames;
  int? companyId; // company_id
  String? companyName;
  double? plannedHours; // planned_hours
  int? stageId; // stage_id
  String? stageName;
  String? priority; // priority
  double? totalHoursSpent; // total_hours_spent
  double? remainingHours; // remaining_hours

  TaskFormated({
    required this.id,
    this.name,
    this.description,
    this.assignedIds,
    this.assignedNames,
    this.clientId,
    this.clientName,
    this.dateEnd,
    this.tagIds,
    this.tagNames,
    this.companyId,
    this.companyName,
    this.plannedHours,
    this.stageId,
    this.stageName,
    this.priority,
    this.totalHoursSpent,
    this.remainingHours
  });

  Task taskFormatedToTask(TaskFormated taskFormated) {
    return Task(
      id: taskFormated.id,
      name: taskFormated.name,
      description: taskFormated.description,
      assignedIds: taskFormated.assignedIds,
      clientId: taskFormated.clientId,
      dateEnd: taskFormated.dateEnd,
      tagIds: taskFormated.tagIds,
      companyId: taskFormated.companyId,
      plannedHours: taskFormated.plannedHours,
      stageId: taskFormated.stageId,
      priority: taskFormated.priority,
      totalHoursSpent: taskFormated.totalHoursSpent,
      remainingHours: taskFormated.remainingHours
    );
  }

  factory TaskFormated.fromJson(Map<String, dynamic> json) {
    return TaskFormated(
      id: json['id'] ?? 0,
      name: parseStringField(json['name']),
      description: parseStringField(json['description']),
      assignedIds: parseListInt(json['assigned_ids']),
      assignedNames: json['assigned_names'] != null ? List<String>.from(json['assigned_names']) : null,
      clientId: parseIntField(json['partner_id']),
      clientName: parseStringField(json['partner_name']),
      dateEnd: parseStringField(json['date_end']),
      tagIds: parseListInt(json['tag_ids']),
      tagNames: json['tag_names'] != null ? List<String>.from(json['tag_names']) : null,
      companyId: parseIntField(json['company_id']),
      companyName: parseStringField(json['company_name']),
      plannedHours: parseDoubleField(json['planned_hours']),
      stageId: parseIntField(json['stage_id']),
      stageName: parseStringField(json['stage_name']),
      priority: parseStringField(json['priority']),
      totalHoursSpent: parseDoubleField(json['total_hours_spent']),
      remainingHours: parseDoubleField(json['remaining_hours']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'assigned_id': assignedIds,
      'assigned_name': assignedNames,
      'client_id': clientId,
      'client_name': clientName,
      'date_end': dateEnd,
      'tag_ids': tagIds,
      'tag_names': tagNames,
      'company_id': companyId,
      'company_name': companyName,
      'planned_hours': plannedHours,
      'stage_id': stageId,
      'stage_name': stageName,
      'priority': priority,
      'total_hours_spent': totalHoursSpent,
      'remaining_hours': remainingHours
    };
  }
}