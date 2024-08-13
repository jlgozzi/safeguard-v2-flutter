import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:postgres/postgres.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';

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

//USER HELPERS

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
    print(result);

    if (result.isNotEmpty) {
      // Salva o userId no SessionManager
      final session = SessionManager();
      session.userId = result[0][0].toString();

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

// PASSWORD HELPERS
// Future<List<dynamic>> fetchPasswords() async {
//   final conn = await database();
//   final session = SessionManager(); // Acessa o userId global
//   final userId = session.userId;

//   if (userId == null) {
//     print('Usuário não está logado');
//     return [];
//   }

//   try {
//     final results = await conn.execute(
//         Sql.named(
//             'SELECT id, description, code FROM passwords WHERE user_id = @userId'),
//         {'userId': userId}); // Passa o userId como parâmetro
//     return results
//         .map((row) => {
//               'id': row[0],
//               'description': row[1],
//               'code': row[2],
//             })
//         .toList();
//   } catch (e) {
//     print('Erro ao buscar senhas: $e');
//     return [];
//   } finally {
//     await conn.close();
//   }
// }

Future<List<dynamic>> fetchPasswords() async {
  final session = SessionManager(); // Acessa o userId global
  final userId = session.userId;

  if (userId == null) {
    print('Usuário não está logado');
  }

  final conn = await database();
  try {
    final results = await conn.execute(
        Sql.named(
            'SELECT id, description, code FROM passwords WHERE user_id = @userId'),
        parameters: {'userId': userId});

    return results
        .map((row) => {
              'id': row[0],
              'description': row[1],
              'code': row[2],
            })
        .toList();
  } catch (e) {
    print('Erro ao buscar senhas: $e');
    return [];
  } finally {
    await conn.close();
  }
}

Future<void> addPassword(String description, String code) async {
  final session = SessionManager(); // Acessa o userId global
  final userId = session.userId;

  if (userId == null) {
    print('Usuário não está logado');
  }

  final conn = await database();
  await conn.execute(
    Sql.named(
        'INSERT INTO passwords (description, code, token, user_id) VALUES (@description, @code, @token, @userId)'),
    parameters: {
      'description': description,
      'code': code,
      'token': 'some_token', // Gere o token conforme necessário
      'userId': userId
    },
  );
  await conn.close();
}

Future<void> editPassword(int id, String description, String code) async {
  final conn = await database();
  await conn.execute(
    Sql.named(
        'UPDATE passwords SET description = @description, code = @code WHERE id = @id'),
    parameters: {
      'description': description,
      'code': code,
      'id': id,
    },
  );
  await conn.close();
}

Future<void> deletePassword(int id) async {
  final conn = await database();
  await conn.execute(
    Sql.named('DELETE FROM passwords WHERE id = @id'),
    parameters: {
      'id': id,
    },
  );
  await conn.close();
}
