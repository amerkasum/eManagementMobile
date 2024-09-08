class UserBasicDto {
  final int id;
  final String fullName;
  final String imageUrl;

  UserBasicDto({
    required this.id,
    required this.fullName,
    required this.imageUrl,
  });

  // Factory constructor to create an instance from a JSON map
  factory UserBasicDto.fromJson(Map<String, dynamic> json) {
    return UserBasicDto(
      id: json['id'],
      fullName: json['fullName'],
      imageUrl: json['imageUrl'],
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'imageUrl': imageUrl,
    };
  }
}
