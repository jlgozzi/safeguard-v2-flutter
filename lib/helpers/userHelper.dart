import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:postgres/postgres.dart';

Future database() async {
  final conn = await Connection.open(
    Endpoint(
        host: 'localhost',
        database: 'safeguard',
        username: 'admin',
        password: 'admin',
        port: 5432),
    settings: const ConnectionSettings(sslMode: SslMode.disable),
  );
  print('Connected!');
  return conn;
}

String hashPassword(String password) {
  final bytes = utf8.encode(password);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<void> createUser(String fullName, String email, String password) async {
  final conn = await database();

  // Verificar se o email já está cadastrado
  final result = await conn.execute(
    Sql.named(r'SELECT COUNT(*) FROM users WHERE email = @email'),
    parameters: {
      'email': email,
    },
  );

  if (result[0][0] > 0) {
    print('Email já cadastrado');
    return;
  }

  // Hash da senha
  final hashedPassword = hashPassword(password);

  await conn!.execute(
    r'INSERT INTO users (full_name, email, password) VALUES ($1, $2, $3)',
    parameters: [
      fullName, email, hashedPassword, // Hash the password before storing it
    ],
  );

  print('User created!');
}

Future<bool> loginUser(String email, String password) async {
  try {
    final conn = await database();

    final result = await conn.execute(
      Sql.named(
          ' SELECT COUNT(*) AS count FROM users WHERE email = @email AND password = @password'),
      parameters: {
        'email': email,
        'password': hashPassword(password),
      },
    );
    print(result.first.toColumnMap());

    await conn.close();

    if (result.isNotEmpty && result[0][0] == 1) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print('Error logging in: $e');
    rethrow;
  }
}
