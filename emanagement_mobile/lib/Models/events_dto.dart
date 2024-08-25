import 'package:intl/intl.dart';

class EventsDto {
  int id;
  String title;
  String subtitle;
  DateTime date;
  String startDateFormatted;
  int eventStatusCode;
  String eventStatusName;
  String imageUrl;

  // Constructor
  EventsDto({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.eventStatusCode,
    required this.eventStatusName,
    required this.imageUrl
  }) : startDateFormatted = DateFormat('dd.MM.yyyy').format(date);

  // fromJson method
  factory EventsDto.fromJson(Map<String, dynamic> json) {
    return EventsDto(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      imageUrl: json['imageUrl'],
      date: DateTime.parse(json['date']),
      eventStatusCode: json['eventStatusCode'],
      eventStatusName: json['eventStatusName'], // Assuming this is provided in the JSON
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'date': date.toIso8601String(),
      'eventStatusCode': eventStatusCode,
      'eventStatusName': eventStatusName,
      'startDateFormatted': startDateFormatted,
    };
  }
}
