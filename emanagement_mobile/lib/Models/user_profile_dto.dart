class UserProfileDto {
  int id;
  String fullName;
  String jobPosition;
  String email;
  String phoneNumber;
  DateTime dateOfBirth;
  String availability;
  String residence;
  String about;
  String formattedDateOfBirth;
  String imageUrl;

  // Constructor
  UserProfileDto({
    required this.id,
    required this.fullName,
    required this.jobPosition,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.formattedDateOfBirth,
    required this.availability,
    required this.residence,
    required this.about,
    required this.imageUrl
  });

  // fromJson method
  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      id: json['id'],
      fullName: json['fullName'],
      jobPosition: json['jobPosition'],
      email: json['email'],
      imageUrl: json['imageUrl'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      formattedDateOfBirth: json['formattedDateOfBirth'],
      availability: json['availability'],
      residence: json['residence'],
      about: json['about'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'jobPosition': jobPosition,
      'email': email,
      'imageUrl': imageUrl,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'formattedDateOfBirth': formattedDateOfBirth,
      'availability': availability,
      'residence': residence,
      'about': about,
    };
  }
}
