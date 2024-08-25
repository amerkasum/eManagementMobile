class UserDesktopDto {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String contractType;
  final DateTime? contractExpireDate;
  final String position;
  final String availability;
  final String formattedContractExpireDate;
  final String imageUrl;

  UserDesktopDto({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.contractType,
    this.contractExpireDate,
    required this.position,
    required this.availability,
    required this.formattedContractExpireDate,
    required this.imageUrl,
  });

  // Convert a UserDesktopDto object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'contractType': contractType,
      'contractExpireDate': contractExpireDate?.toIso8601String(),
      'position': position,
      'imageUrl': imageUrl,
      'availability': availability,
      'formattedContractExpireDate': formattedContractExpireDate,
    };
  }

  // Create a UserDesktopDto object from a JSON map
  factory UserDesktopDto.fromJson(Map<String, dynamic> json) {
    return UserDesktopDto(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      imageUrl: json['imageUrl'] as String,
      phoneNumber: json['phoneNumber'] as String,
      contractType: json['contractType'] as String,
      contractExpireDate: json['contractExpireDate'] != null
          ? DateTime.parse(json['contractExpireDate'] as String)
          : null,
      position: json['position'] as String,
      availability: json['availability'] as String,
      formattedContractExpireDate: json['formattedContractExpireDate'] as String,
    );
  }
}
