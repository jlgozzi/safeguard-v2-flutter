import 'package:postgres/postgres.dart';
import 'package:safeguard_v2/database/config.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';

Future<List<dynamic>> fetchAccounts() async {
  final session = SessionManager(); // Acessa o userId global
  final userId = session.userId;

  if (userId == null) {
    print('Usuário não está logado');
    return [];
  }

  final conn = await database();
  try {
    final results = await conn.execute(
      Sql.named('''
          SELECT 
            a.id, 
            a.category_id, 
            c.description as category_description, 
            a.description, 
            a.url, 
            a.password_id, 
            a.is_visible 
          FROM accounts a 
          LEFT JOIN categories c ON a.category_id = c.id 
          WHERE a.user_id = @userId
          '''),
      parameters: {'userId': userId},
    );

    return results
        .map((row) => {
              'id': row[0],
              'category_id': row[1],
              'category_description': row[2],
              'description': row[3],
              'url': row[4],
              'password_id': row[5],
              'is_visible': row[6],
            })
        .toList();
  } catch (e) {
    print('Erro ao buscar contas: $e');
    return [];
  } finally {
    await conn.close();
  }
}

Future<void> addAccount(
    String description, String? url, int? categoryId, int? passwordId) async {
  final session = SessionManager(); // Acessa o userId global
  final userId = session.userId;

  if (userId == null) {
    print('Usuário não está logado');
    return;
  }

  final conn = await database();
  try {
    await conn.execute(
      Sql.named('''
          INSERT INTO accounts 
          (description, url, category_id, password_id, is_visible, user_id) 
          VALUES 
          (@description, @url, @categoryId, @passwordId, @isVisible, @userId)
          '''),
      parameters: {
        'description': description,
        'url': url,
        'categoryId': categoryId,
        'passwordId': passwordId,
        'isVisible': true,
        'userId': userId,
      },
    );
  } catch (e) {
    print('Erro ao adicionar conta: $e');
  } finally {
    await conn.close();
  }
}

Future<void> editAccount(int id, String description, String? url,
    int? categoryId, int? passwordId, bool isVisible) async {
  final conn = await database();
  try {
    await conn.execute(
      Sql.named('''
          UPDATE accounts 
          SET 
            description = @description, 
            url = @url, 
            category_id = @categoryId, 
            password_id = @passwordId, 
            is_visible = @isVisible 
          WHERE 
            id = @id
          '''),
      parameters: {
        'description': description,
        'url': url,
        'categoryId': categoryId,
        'passwordId': passwordId,
        'isVisible': isVisible,
        'id': id,
      },
    );
  } catch (e) {
    print('Erro ao editar conta: $e');
  } finally {
    await conn.close();
  }
}

Future<void> deleteAccount(int id) async {
  final conn = await database();
  try {
    await conn.execute(
      Sql.named('DELETE FROM accounts WHERE id = @id'),
      parameters: {
        'id': id,
      },
    );
  } catch (e) {
    print('Erro ao excluir conta: $e');
  } finally {
    await conn.close();
  }
}
