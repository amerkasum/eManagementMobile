import 'package:emanagement_mobile/Models/Helpers/working_days_basic_dto.dart';

class WorkingDaysDto {
  final int userId;
  final String fullName;
  final String? imageUrl;
  final List<WorkingDaysBasicDto> workingDays;

  WorkingDaysDto({
    required this.userId,
    required this.fullName,
    required this.imageUrl,
    required this.workingDays,
  });

  factory WorkingDaysDto.fromJson(Map<String, dynamic> json) {
    return WorkingDaysDto(
      userId: json['userId'],
      fullName: json['fullName'],
      imageUrl: json['imageUrl'],
      workingDays: (json['workingDays'] as List<dynamic>)
          .map((day) => WorkingDaysBasicDto.fromJson(day))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'imageUrl': imageUrl,
      'workingDays': workingDays.map((e) => e.toJson()).toList(),
    };
  }
}
