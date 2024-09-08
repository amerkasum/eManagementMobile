class WorkingAbsenceViewModel {
  int absenceTypeId;
  DateTime startDate;
  DateTime? endDate;
  String? note;
  int userId;

  WorkingAbsenceViewModel({
    required this.absenceTypeId,
    required this.startDate,
    this.endDate,
    this.note,
    required this.userId,
  });

  factory WorkingAbsenceViewModel.fromJson(Map<String, dynamic> json) {
    return WorkingAbsenceViewModel(
      absenceTypeId: json['absenceTypeId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      note: json['note'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'absenceTypeId': absenceTypeId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'note': note,
      'userId': userId,
    };
  }
}
