class EventViewModel {
  String? title;
  String? subtitle;
  String? description;
  DateTime? date;
  int? createdById;
  String? imageUrl; // Optional
  int? eventStatusId;

  EventViewModel({
    this.title,
    this.subtitle,
    this.description,
    this.date,
    this.createdById,
    this.imageUrl,
    this.eventStatusId,
  });


  factory EventViewModel.fromJson(Map<String, dynamic> json) {
    return EventViewModel(
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      createdById: json['createdById'],
      imageUrl: json['imageUrl'], 
      eventStatusId: json['eventStatusId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'date': date?.toIso8601String(),
      'createdById': createdById,
      'imageUrl': imageUrl, 
      'eventStatusId': eventStatusId,
    };
  }
}
