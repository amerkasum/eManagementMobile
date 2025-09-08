class WorkingDaysBasicDto {
  final int workingDayId;
  final int day;
  final String dayName;
  final int shiftId;
  final String shiftName;
  bool isWorking;

  WorkingDaysBasicDto({
    required this.workingDayId,
    required this.day,
    required this.dayName,
    required this.shiftId,
    required this.shiftName,
    required this.isWorking,
  });

  factory WorkingDaysBasicDto.fromJson(Map<String, dynamic> json) {
    return WorkingDaysBasicDto(
      workingDayId: json['workingDayId'],
      day: json['day'],
      dayName: json['dayName'],
      shiftId: json['shiftId'],
      shiftName: json['shiftName'],
      isWorking: json['isWorking'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workingDayId': workingDayId,
      'day': day,
      'dayName': dayName,
      'shiftId': shiftId,
      'shiftName': shiftName,
      'isWorking': isWorking,
    };
  }
}
