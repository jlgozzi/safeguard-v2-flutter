import 'package:postgres/postgres.dart';
import 'package:safeguard_v2/database/config.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';

Future<List<dynamic>> fetchLogs() async {
  final session = SessionManager();
  final userId = session.userId;
  final conn = await database();

  try {
    final results = await conn.execute(
      Sql.named('''
    SELECT id, user_id, table_name, action, description, created_at 
    FROM logs 
    WHERE user_id = @userId
    ORDER BY id DESC
  '''),
      parameters: {'userId': userId},
    );

    print(results);

    return results
        .map((row) => {
              'id': results[0][0],
              'user_id': results[0][1],
              'table_name': results[0][2],
              'action': results[0][3],
              'description': results[0][4],
              'created_at': results[0][5],
            })
        .toList();
  } catch (e) {
    print('Erro ao buscar logs: $e');
    return [];
  } finally {
    await conn.close();
  }
}
