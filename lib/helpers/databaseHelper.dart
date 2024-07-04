import 'package:postgres/postgres.dart';

import '../database/config.dart';

class DatabaseHelper {
  Connection? _connection;

  Future<void> connect() async {
    _connection = await database();
  }

  Future<void> createUser(
      String username, String email, String password) async {
    if (_connection == null) {
      await connect();
    }
    await _connection!.execute(
      r'INSERT INTO users (username, email, password) VALUES (@username, @Email, @password)',
      parameters: [
        {
          'username': username,
          'email': email,
          'password': password, // Hash the password before storing it
        }
      ],
    );
  }

  // Adicione mais métodos conforme necessário, por exemplo:
  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    if (_connection == null) {
      await connect();
    }
    final results = await _connection!.execute(
      'SELECT * FROM users WHERE username = @username',
      parameters: [
        {
          'username': username,
        }
      ],
    );
    if (results.isEmpty) return null;
    return results.first.toColumnMap();
  }

  // Outros métodos como autenticação, gerenciamento de senhas, etc.
}
