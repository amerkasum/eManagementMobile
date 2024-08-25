class SelectListHelper {
  final int id;
  final String name;
  final String code;

  SelectListHelper({required this.id, required this.name, required this.code});

  factory SelectListHelper.fromJson(Map<String, dynamic> json) {
    return SelectListHelper(
      id: json['id'],
      name: json['name'],
      code: json['code']
    );
  }
}

