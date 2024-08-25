class TaskDto {
  int id;
  String name;
  int priority;
  String location;
  String usersAssigned;
  int statusCode;

  TaskDto({
    required this.id,
    required this.name,
    required this.priority,
    required this.location,
    required this.usersAssigned,
    required this.statusCode,
  });

  factory TaskDto.fromJson(Map<String, dynamic> json) {
    return TaskDto(
      id: json['id'],
      name: json['name'],
      priority: json['priority'],
      location: json['location'],
      usersAssigned: json['usersAssigned'],
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'priority': priority,
      'location': location,
      'usersAssigned': usersAssigned,
      'statusCode': statusCode,
    };
  }
}
