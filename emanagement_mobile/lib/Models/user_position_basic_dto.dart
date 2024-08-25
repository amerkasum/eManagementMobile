class UserPositionBasicDto {
  final int userId;
  final String fullName;
  final String positionName;

  UserPositionBasicDto({
    required this.userId,
    required this.fullName,
    required this.positionName,
  });

  factory UserPositionBasicDto.fromJson(Map<String, dynamic> json) {
    return UserPositionBasicDto(
      userId: json['userId'] as int,
      fullName: json['fullName'] as String,
      positionName: json['positionName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'positionName': positionName,
    };
  }
}
