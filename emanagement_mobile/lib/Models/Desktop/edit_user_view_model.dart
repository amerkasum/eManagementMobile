class EditUserViewModel {
  int id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  int? roleId;
  int? cityId;
  int? shiftId;
  int? positionId;
  int? contractTypeId;
  DateTime? contractExpireDate;
  DateTime? dateOfBirth;
  String? imageUrl;
  String? about;

  EditUserViewModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.roleId,
    this.cityId,
    this.shiftId,
    this.positionId,
    this.contractTypeId,
    this.contractExpireDate,
    this.dateOfBirth,
    this.imageUrl,
    this.about,
  });

  factory EditUserViewModel.fromJson(Map<String, dynamic> json) {
     return EditUserViewModel(
       id: json['id'],
       firstName: json['firstName'],
       lastName: json['lastName'],
       email: json['email'],
       phoneNumber: json['phoneNumber'],
       roleId: json['roleId'],
       cityId: json['cityId'],
       shiftId: json['shiftId'],
       positionId: json['positionId'],
       contractTypeId: json['contractTypeId'],
       contractExpireDate: json['contractExpireDate'] != null
           ? DateTime.parse(json['contractExpireDate'])
           : null,
       dateOfBirth: json['dateOfBirth'] != null
           ? DateTime.parse(json['dateOfBirth'])
           : null,
       imageUrl: json['imageUrl'],
       about: json['about'],
     );
   }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'roleId': roleId,
      'cityId': cityId,
      'shiftId': shiftId,
      'positionId': positionId,
      'contractTypeId': contractTypeId,
      'contractExpireDate': contractExpireDate?.toIso8601String(),
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'imageUrl': imageUrl,
      'about': about,
    };
  }
}
