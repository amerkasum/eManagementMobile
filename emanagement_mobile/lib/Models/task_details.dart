import 'package:emanagement_mobile/Models/user_position_basic_dto.dart';

class TaskDetailsDto {
  final int id;
  final String name;
  final String location;
  final String status;
  final String priority;
  final DateTime? dueDate;
  final String dueDateFormatted;
  final String calculatedDays;
  final String description;
  final List<UserPositionBasicDto> users;
  final bool allowedReview;

  TaskDetailsDto({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.dueDateFormatted,
    required this.priority,
    required this.dueDate,
    required this.calculatedDays,
    required this.description,
    required this.users,
    required this.allowedReview
  });

  factory TaskDetailsDto.fromJson(Map<String, dynamic> json) {
    return TaskDetailsDto(
      id: json['id'] as int,
      name: json['name'] as String,
      location: json['location'] as String,
      status: json['status'] as String,
      priority: json['priority'] as String,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      dueDateFormatted: json['dueDateFormatted'] as String,
      calculatedDays: json['calculatedDays'] as String,
      description: json['description'] as String,
      allowedReview: json['allowedReview'] as bool,
      users: (json['users'] as List<dynamic>)
          .map((e) => UserPositionBasicDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'status': status,
      'allowedReview': allowedReview,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'dueDateFormatted' : dueDateFormatted,
      'calculatedDays': calculatedDays,
      'description': description,
      'users': users.map((e) => e.toJson()).toList(),
    };
  }
}
