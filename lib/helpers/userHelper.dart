import 'package:postgres/postgres.dart';

Future database() async {
  final conn = await Connection.open(
    Endpoint(
        host: 'localhost',
        database: 'safeguard',
        username: 'postgres',
        password: 'admin',
        port: 5433),
    settings: const ConnectionSettings(sslMode: SslMode.disable),
  );
  print('Connected!');
  return conn;
}

Future<void> createUser(String username, String email, String password) async {
  final conn = await database();

  await conn!.execute(
    r'INSERT INTO users (username, email, password) VALUES ($1, $2, $3)',
    parameters: [
      username, email, password, // Hash the password before storing it
    ],
  );

  print('User created!');
}

Future<bool> loginUser(String username, String password) async {
  try {
    final conn = await database();

    final result = await conn.query(
      '''
      SELECT COUNT(*) AS count
      FROM users
      WHERE username = @username AND password = @password
      ''',
      substitutionValues: {
        'username': username,
        'password': password,
      },
    );

    await conn.close();

    if (result.isNotEmpty && result[0]['count'] == 1) {
      return true; // Usuário autenticado com sucesso
    } else {
      return false; // Credenciais inválidas
    }
  } catch (e) {
    print('Error logging in: $e');
    rethrow;
  }
}
