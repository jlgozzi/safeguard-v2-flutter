import 'dart:math';

import 'package:postgres/postgres.dart';
import 'package:safeguard_v2/database/config.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';

Future<void> addCategory(String description) async {
  final session = SessionManager(); // Acessa o userId global
  final userId = session.userId;

  if (userId == null) {
    print('Usuário não está logado');
  }

  final conn = await database();
  await conn.execute(
    Sql.named(
        'INSERT INTO categories (description, user_id) VALUES (@description, @userId)'),
    parameters: {'description': description, 'userId': userId},
  );
  SessionManager().reload();

  await conn.close();
}

Future<List<dynamic>> fetchCategories() async {
  final session = SessionManager(); // Acessa o userId global
  final userId = session.userId;

  if (userId == null) {
    print('Usuário não está logado');
  }

  final conn = await database();
  try {
    final results = await conn.execute(
        Sql.named(
            'SELECT id, description FROM categories WHERE user_id = @userId ORDER BY id DESC'),
        parameters: {'userId': userId});

    print(results);

    return results
        .map((row) => {
              'id': row[0],
              'description': row[1],
            })
        .toList();
  } catch (e) {
    print('Erro ao buscar categorias: $e');
    return [];
  } finally {
    await conn.close();
  }
}

Future<void> editCategory(int id, String description) async {
  final conn = await database();
  try {
    await conn.execute(
      Sql.named('''
        UPDATE categories 
        SET 
          description = @description
        WHERE 
          id = @id
        '''),
      parameters: {
        'description': description,
        'id': id,
      },
    );
    SessionManager().reload();
  } catch (e) {
    print('Erro ao editar conta: $e');
  } finally {
    await conn.close();
  }
}

Future<void> deleteCategory(int id) async {
  final conn = await database();
  try {
    await conn.execute(
      Sql.named('DELETE FROM categories WHERE id = @id'),
      parameters: {
        'id': id,
      },
    );
    SessionManager().reload();
  } catch (e) {
    print('Erro ao excluir conta: $e');
  } finally {
    await conn.close();
  }
}
