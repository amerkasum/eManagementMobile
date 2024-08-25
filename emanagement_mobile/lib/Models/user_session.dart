class UserSession {
  static final UserSession _instance = UserSession._internal();
  int? userId;

  factory UserSession() {
    return _instance;
  }

  void setUserId(int? id) {
    userId = id;
  }

  int? get _userId => userId;

  UserSession._internal();
}