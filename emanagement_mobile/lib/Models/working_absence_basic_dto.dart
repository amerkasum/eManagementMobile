class WorkingAbsenceBasicDto {
  int id;
  String absenceType;
  String fullName;
  String imageUrl;
  String absenceStatus;
  String date;
  String note;

  WorkingAbsenceBasicDto({
    required this.id,
    required this.absenceType,
    required this.fullName,
    required this.absenceStatus,
    required this.date,
    required this.imageUrl,
    required this.note
  });

  // Factory method to create an instance from JSON
  factory WorkingAbsenceBasicDto.fromJson(Map<String, dynamic> json) {
    return WorkingAbsenceBasicDto(
      id: json['id'],
      absenceType: json['absenceType'],
      fullName: json['fullName'],
      imageUrl: json['imageUrl'],
      absenceStatus: json['absenceStatus'],
      date: json['date'],
      note: json['note'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'absenceType': absenceType,
      'fullName': fullName,
      'imageUrl': imageUrl,
      'absenceStatus': absenceStatus,
      'date': date,
      'note': note
    };
  }
}
