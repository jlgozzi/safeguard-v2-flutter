import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:postgres/postgres.dart';
import 'package:safeguard_v2/database/config.dart';
import 'package:safeguard_v2/helpers/dbHelper.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';

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
    throw 'Email já cadastrado';
  }

  final hashedPassword = hashPassword(password);

  await conn!.execute(
    r'INSERT INTO users (full_name, email, password) VALUES ($1, $2, $3)',
    parameters: [
      fullName, email, hashedPassword, // Hash the password before storing it
    ],
  );

  print('User created!');
  await conn.close();
}

Future<Map<String, dynamic>?> loginUser(String email, String password) async {
  try {
    final conn = await database();

    final result = await conn.execute(
      Sql.named(
          'SELECT id, full_name, email, profile_picture FROM users WHERE email = @email AND password = @password'),
      parameters: {
        'email': email,
        'password': hashPassword(password),
      },
    );
    await conn.close();

    if (result.isNotEmpty) {
      // Salva o userId no SessionManager
      final session = SessionManager();
      session.userId = result[0][0].toString();

      // Busca e seta categorias e passwords
      await session.reload();

      // Retorna os dados do usuário
      return {
        'id': result[0][0].toString(),
        'full_name': result[0][1],
        'email': result[0][2],
        'profile_picture': result[0][3],
      };
    } else {
      return null; // Usuário não encontrado
    }
  } catch (e) {
    print('Error logging in: $e');
    rethrow;
  }
}
