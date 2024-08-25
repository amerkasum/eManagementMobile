class EventDetailsDto {
  final int id;
  final String title;
  final String subtitle;
  final String description;
  final int createdById;
  final String createdByFullName;
  final DateTime date;
  final int eventStatusCode;
  final String formattedDate; 
  final String eventStatusName; 
  final String imageUrl;

  EventDetailsDto({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.createdById,
    required this.createdByFullName,
    required this.date,
    required this.eventStatusCode,
    required this.formattedDate,
    required this.eventStatusName,
    required this.imageUrl
  });

  factory EventDetailsDto.fromJson(Map<String, dynamic> json) {
    return EventDetailsDto(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      createdById: json['createdById'],
      createdByFullName: json['createdByFullName'],
      date: DateTime.parse(json['date']),
      eventStatusCode: json['eventStatusCode'],
      formattedDate: json['formattedDate'], // Assigned directly from JSON
      eventStatusName: json['eventStatusName'], // Assigned directly from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'description': description,
      'createdById': createdById,
      'createdByFullName': createdByFullName,
      'date': date.toIso8601String(),
      'eventStatusCode': eventStatusCode,
      'formattedDate': formattedDate, // Directly added to JSON
      'eventStatusName': eventStatusName, // Directly added to JSON
    };
  }
}
