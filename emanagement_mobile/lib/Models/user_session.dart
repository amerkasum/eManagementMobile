class UserSession {
  // Singleton instance
  static final UserSession _instance = UserSession._internal();

  // Properties to store user information
  int? _userId;
  String? _fullName;
  String? _imageUrl;
  String? _role; // Added role property

  // Private constructor
  UserSession._internal();

  // Factory constructor to return the singleton instance
  factory UserSession() {
    return _instance;
  }

  // Getter and Setter for userId
  int? get userId => _userId;
  set userId(int? id) {
    _userId = id;
  }

  // Getter and Setter for fullName
  String? get fullName => _fullName;
  set fullName(String? name) {
    _fullName = name;
  }

  // Getter and Setter for imageUrl
  String? get imageUrl => _imageUrl;
  set imageUrl(String? url) {
    _imageUrl = url;
  }

  // Getter and Setter for role
  String? get role => _role;
  set role(String? roleValue) {
    _role = roleValue;
  }

  // Method to clear user data (optional, useful for logout)
  void clearSession() {
    _userId = null;
    _fullName = null;
    _imageUrl = null;
    _role = null; // Clear the role as well
  }
}
