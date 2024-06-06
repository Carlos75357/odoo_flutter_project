import 'package:flutter_crm_prove/domain/parse_types.dart';

class Task {
  int id;
  String? name;
  String? description;
  List<int>? assignedId; // user_ids
  int? clientId;
  int? milestone; // milestone_id
  String? dateEnd; // date_end
  List<int>? tagIds;
  int? companyId; // company_id
  double? plannedHours; // planned_hours
  int? stageId; // stage_id
  String? priority; // priority
  double? totalHoursSpent; // total_hours_spent
  double? remainingHours; // remaining_hours

  Task({
    required this.id,
    this.name,
    this.description,
    this.assignedId,
    this.clientId,
    this.milestone,
    this.dateEnd,
    this.tagIds,
    this.companyId,
    this.plannedHours,
    this.stageId,
    this.priority,
    this.totalHoursSpent,
    this.remainingHours
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      name: parseStringField(json['name']),
      description: parseStringField(json['description']),
      assignedId: parseListInt(json['manager_id']),
      clientId: parseIntField(json['partner_id']),
      milestone: parseStringField(json['milestone']),
      dateEnd: parseStringField(json['date_end']),
      tagIds: parseListInt(json['tag_ids']),
      companyId: parseIntField(json['company_id']),
      plannedHours: parseDoubleField(json['planned_hours']),
      stageId: parseIntField(json['stage_id']),
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
      'assigned': assignedId,
      'client': clientId,
      'milestone': milestone,
      'date_end': dateEnd,
      'tag_ids': tagIds,
      'company': companyId,
      'planned_hours': plannedHours,
      'stage_id': stageId,
      'priority': priority,
      'total_hours_spent': totalHoursSpent,
      'remaining_hours': remainingHours
    };
  }
}