import 'package:flutter_crm_prove/domain/parse_types.dart';

class Task {
  int id;
  String? name;
  String? description;
  List<int>? assigned; // user_ids
  String? client;
  String? milestone; // milestone_id
  String? dateEnd; // date_end
  List<int>? tagIds;
  String? company; // company_id
  double? plannedHours; // planned_hours
  int? stageId; // stage_id
  int? priority; // priority
  double? totalHoursSpent; // total_hours_spent
  double? remainingHours; // remaining_hours

  Task({
    required this.id,
    this.name,
    this.description,
    this.assigned,
    this.client,
    this.milestone,
    this.dateEnd,
    this.tagIds,
    this.company,
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
      assigned: parseListInt(json['assigned']),
      client: parseStringField(json['client']),
      milestone: parseStringField(json['milestone']),
      dateEnd: parseStringField(json['date_end']),
      tagIds: parseListInt(json['tag_ids']),
      company: parseStringField(json['company']),
      plannedHours: parseDoublefield(json['planned_hours']),
      stageId: parseIntField(json['stage_id']),
      priority: parseIntField(json['priority']),
      totalHoursSpent: parseDoublefield(json['total_hours_spent']),
      remainingHours: parseDoublefield(json['remaining_hours']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'assigned': assigned,
      'client': client,
      'milestone': milestone,
      'date_end': dateEnd,
      'tag_ids': tagIds,
      'company': company,
      'planned_hours': plannedHours,
      'stage_id': stageId,
      'priority': priority,
      'total_hours_spent': totalHoursSpent,
      'remaining_hours': remainingHours
    };
  }
}