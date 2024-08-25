class UserViewModel {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? phoneNumber;
  int? roleId;
  int? cityId;
  int? shiftId;
  int? positionId;
  int? contractTypeId;
  DateTime? contractExpireDate;
  DateTime? dateOfBirth;
  bool active;
  String? imageUrl;

  UserViewModel({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.phoneNumber,
    this.roleId,
    this.cityId,
    this.shiftId,
    this.positionId,
    this.contractTypeId,
    this.contractExpireDate,
    this.dateOfBirth,
    this.active = true,
    this.imageUrl,
  });

  factory UserViewModel.fromJson(Map<String, dynamic> json) {
    return UserViewModel(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      roleId: json['roleId'] as int?,
      cityId: json['cityId'] as int?,
      imageUrl: json['imageUrl'] as String?,
      shiftId: json['shiftId'] as int?,
      positionId: json['positionId'] as int?,
      contractTypeId: json['contractTypeId'] as int?,
      contractExpireDate: json['contractExpireDate'] != null
          ? DateTime.parse(json['contractExpireDate'] as String)
          : null,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      active: json['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'roleId': roleId,
      'imageUrl': imageUrl,
      'cityId': cityId,
      'shiftId': shiftId,
      'positionId': positionId,
      'contractTypeId': contractTypeId,
      'contractExpireDate':
          contractExpireDate?.toIso8601String(), // Convert DateTime to ISO string
      'dateOfBirth': dateOfBirth?.toIso8601String(), // Convert DateTime to ISO string
      'active': active,
    };
  }
}
