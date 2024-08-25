import 'package:postgres/postgres.dart';
import 'package:safeguard_v2/database/config.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';

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
            'SELECT id, description, code FROM passwords WHERE user_id = @userId ORDER BY id DESC'),
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
  final session = SessionManager();
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
  await session.reload();

  await conn.close();
}

Future<void> editPassword(int id, String description, String code) async {
  final session = SessionManager();

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
  await session.reload();

  await conn.close();
}

Future<void> deletePassword(int id) async {
  final session = SessionManager();

  final conn = await database();
  await conn.execute(
    Sql.named('DELETE FROM passwords WHERE id = @id'),
    parameters: {
      'id': id,
    },
  );
  await session.reload();

  await conn.close();
}

//CATEGORY HELPERS
