class UserDto {
  final int id;
  final String fullName;
  final String email;
  final String jobPositionCode;
  final String jobPositionName;
  final String phoneNumber;
  final String availability;
  final String imageUrl;

  const UserDto({
    required this.id,
    required this.fullName,
    required this.email,
    required this.jobPositionCode,
    required this.jobPositionName,
    required this.phoneNumber,
    required this.availability,
    required this.imageUrl
  });

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    id: json['id'],
    fullName: json['fullName'],
    email: json['email'],
    imageUrl: json['imageUrl'],
    jobPositionCode: json['jobPositionCode'],
    jobPositionName: json['jobPositionName'],
    phoneNumber: json['phoneNumber'],
    availability: json['availability'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "email": email,
    "imageUrl": imageUrl,
    "jobPositionCode": jobPositionCode,
    "jobPositionName": jobPositionName,
    "phoneNumber": phoneNumber,
    "availability": availability,
  };
}
