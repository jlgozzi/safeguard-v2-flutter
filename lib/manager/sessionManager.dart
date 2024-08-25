import 'package:safeguard_v2/helpers/categoryHelper.dart';
import 'package:safeguard_v2/helpers/passwordsHelper.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  String? userId;
  List<dynamic> categories = [];
  List<dynamic> passwords = []; // Adicione essa lista para armazenar as senhas

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  Future<void> reload() async {
    categories = await fetchCategories();
    passwords = await fetchPasswords();
  }
}
