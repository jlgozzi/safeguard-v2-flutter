import 'package:safeguard_v2/helpers/accountHelper.dart';
import 'package:safeguard_v2/helpers/categoryHelper.dart';
import 'package:safeguard_v2/helpers/configHelper.dart';
import 'package:safeguard_v2/helpers/logHelper.dart';
import 'package:safeguard_v2/helpers/passwordsHelper.dart';
import 'package:safeguard_v2/helpers/userHelper.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  String? userId;

  List<dynamic> categories = [];
  List<dynamic> passwords = [];
  List<dynamic> accounts = [];
  List<dynamic> logs = [];

  Map<String, dynamic>? userConfig;
  Map<String, dynamic>? user;

  bool get isDarkMode {
    return userConfig?['is_dark'] ??
        false; // Retorna false se userConfig ou IsDark for nulo
  }

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  Future<void> reload() async {
    categories = await fetchCategories();
    passwords = await fetchPasswords();
    accounts = await fetchAccounts();
    userConfig = await fetchUserConfigs();
    logs = await fetchLogs();
    user = await fetchUser();
  }
}
