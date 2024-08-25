import 'package:postgres/postgres.dart';
import 'package:safeguard_v2/database/config.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';

Future<List<dynamic>> fetchLogs() async {
  final session = SessionManager(); // Acessa o userId global
  final userId = session.userId;

  if (userId == null) {
    print('Usuário não está logado');
  }

  final conn = await database();
  try {
    final results = await conn.execute(
        Sql.named(
            'SELECT id, table_name, action, description, created_at FROM logs WHERE user_id = @userId ORDER BY id DESC'),
        parameters: {'userId': userId});

    print(results);

    return results
        .map((row) => {
              'id': row[0],
              'table_name': row[1],
              'action': row[2],
              'description': row[3],
              'created_at': row[4],
            })
        .toList();
  } catch (e) {
    print('Erro ao buscar logs: $e');
    return [];
  } finally {
    await conn.close();
  }
}
