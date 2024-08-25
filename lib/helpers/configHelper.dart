import 'package:postgres/postgres.dart';
import 'package:safeguard_v2/database/config.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';

// Função para buscar as configurações do usuário
Future<Map<String, dynamic>?> fetchUserConfigs() async {
  final session = SessionManager();
  final userId = session.userId;
  final conn = await database();
  final result = await conn.execute(
    Sql.named('''
    SELECT id, user_id, is_dark, is_pass_visible, is_name_visible, created_at, updated_at 
    FROM user_configs 
    WHERE user_id = @userId
    '''),
    parameters: {'userId': userId},
  );
  await conn.close();

  if (result.isNotEmpty) {
    return {
      'id': result[0][0],
      'user_id': result[0][1],
      'is_dark': result[0][2],
      'is_pass_visible': result[0][3],
      'is_name_visible': result[0][4],
      'created_at': result[0][5],
      'updated_at': result[0][6],
    };
  } else {
    return null;
  }
}

Future<void> updateUserConfigs(
    bool isDark, bool isPassVisible, bool isNameVisible) async {
  try {
    final conn = await database();

    final session = SessionManager();
    final userId = session.userId;

    await conn.execute(
      Sql.named(
          'UPDATE user_configs SET is_dark = @isDark, is_pass_visible = @isPassVisible, is_name_visible = @isNameVisible, updated_at = NOW() WHERE user_id = @userId'),
      parameters: {
        'isDark': isDark,
        'isPassVisible': isPassVisible,
        'isNameVisible': isNameVisible,
        'userId': userId,
      },
    );

    await conn.close();
  } catch (e) {
    print('Error updating user configs: $e');
    rethrow;
  }
}
