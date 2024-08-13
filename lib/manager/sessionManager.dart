class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  String? userId;

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();
}
