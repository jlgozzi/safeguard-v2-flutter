import 'package:postgres/postgres.dart';
import 'package:safeguard_v2/database/config.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';

Future<void> addCard(String number, String code, String dueDate,
    int? passwordId, int? accountId) async {
  final session = SessionManager();
  final userId = session.userId;

  print({
    'number': number,
    'code': code,
    'dueDate': dueDate,
    'passwordId': passwordId,
    'account_id': accountId,
  });

  if (userId == null) {
    print('Usuário não está logado');
    return;
  }

  final conn = await database();
  try {
    await conn.execute(
      Sql.named(
          '''INSERT INTO cards (number, code, due_date, password_id, user_id, account_id) 
         VALUES (@number, @code, @dueDate, @passwordId, @userId, @accountId)'''),
      parameters: {
        'number': number,
        'code': code,
        'dueDate': dueDate,
        'passwordId': passwordId,
        'userId': userId,
        'accountId': accountId
      },
    );
  } catch (e) {
    print('Erro ao adicionar cartão: $e');
  } finally {
    await conn.close();
  }
}

Future<List<dynamic>> fetchCards() async {
  final session = SessionManager();
  final userId = session.userId;

  if (userId == null) {
    print('Usuário não está logado');
    return [];
  }

  final conn = await database();
  try {
    final results = await conn.execute(
      Sql.named(
          '''SELECT id, number, code, due_date, password_id, account_id FROM cards WHERE user_id = @userId'''),
      parameters: {'userId': userId},
    );

    return results
        .map((row) => {
              'id': row[0],
              'number': row[1],
              'code': row[2],
              'due_date': row[3],
              'password_id': row[4],
              'account_id': row[5]
            })
        .toList();
  } catch (e) {
    print('Erro ao buscar cartões: $e');
    return [];
  } finally {
    await conn.close();
  }
}

Future<void> editCard(int id, String number, String code, String dueDate,
    int? passwordId, int? accountId) async {
  print({
    'number': number,
    'code': code,
    'dueDate': dueDate,
    'passwordId': passwordId,
    'account_id': accountId,
    'id': id,
  });
  final conn = await database();
  try {
    await conn.execute(
      Sql.named('''UPDATE cards 
         SET number = @number, code = @code, due_date = @dueDate, password_id = @passwordId, account_id = @account_id
         WHERE id = @id'''),
      parameters: {
        'number': number,
        'code': code,
        'dueDate': dueDate,
        'passwordId': passwordId,
        'account_id': accountId,
        'id': id,
      },
    );
  } catch (e) {
    print('Erro ao editar cartão: $e');
  } finally {
    await conn.close();
  }
}

Future<void> deleteCard(int id) async {
  final conn = await database();
  try {
    await conn.execute(
      Sql.named('DELETE FROM cards WHERE id = @id'),
      parameters: {'id': id},
    );
  } catch (e) {
    print('Erro ao excluir cartão: $e');
  } finally {
    await conn.close();
  }
}
