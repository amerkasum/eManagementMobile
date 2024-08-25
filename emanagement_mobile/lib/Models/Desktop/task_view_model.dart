class TaskViewModel {
  String name;
  String description;
  DateTime? dueDate;
  int priority;
  int taskPriorityId;
  int taskStatusId;
  int cityId;
  List<int> userIds;

  TaskViewModel({
    required this.name,
    required this.description,
    this.dueDate,
    required this.priority,
    required this.taskPriorityId,
    required this.taskStatusId,
    required this.userIds,
    required this.cityId
  });

  // Create an instance of TaskViewModel from a JSON map
  factory TaskViewModel.fromJson(Map<String, dynamic> json) {
    return TaskViewModel(
      name: json['name'] as String,
      description: json['description'] as String,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      priority: json['priority'] as int,
      taskPriorityId: json['taskPriorityId'] as int,
      taskStatusId: json['taskStatusId'] as int,
      cityId: json['cityId'] as int,
      userIds: (json['userIds'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

  // Convert an instance of TaskViewModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
      'taskPriorityId': taskPriorityId,
      'taskStatusId': taskStatusId,
      'userIds': userIds,
      'cityId': cityId
    };
  }
}
