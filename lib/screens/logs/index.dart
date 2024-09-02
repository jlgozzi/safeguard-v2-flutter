import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safeguard_v2/manager/sessionManager.dart'; // Certifique-se de que o caminho está correto

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  late Future<void> _loadLogsFuture;
  final bool _isDark = SessionManager().isDarkMode;

  @override
  void initState() {
    super.initState();
    _loadLogsFuture =
        SessionManager().reload(); // Recarregar todos os dados, incluindo logs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.symmetric(
              vertical: 8.0, horizontal: 16.0), // Padding maior
          decoration: BoxDecoration(
            color: Colors.black54, // Cor de fundo
            borderRadius: BorderRadius.circular(20), // Borda arredondada
          ),
          child: const Text(
            'Histórico',
            style: TextStyle(
              color: Colors.white, // Cor do texto
              fontWeight: FontWeight.bold, // Negrito
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 34, 193, 145),
      ),
      body: FutureBuilder<void>(
        future: _loadLogsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final logs = SessionManager().logs; // Acessa os logs já carregados

            if (logs.isEmpty) {
              return const Center(child: Text('Nenhum registro encontrado.'));
            } else {
              return ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final DateTime createdAt = log[
                      'created_at']; // Assume que 'created_at' é um DateTime
                  final formattedDate =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(createdAt);

                  return ListTile(
                    title: Text(
                      '${log['action']} on ${log['table_name']} [ID: ${log['id']}]',
                      style: TextStyle(
                        color: _isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      '${log['description']}\nUser ID: ${log['user_id']}',
                      style: TextStyle(
                        color: _isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    trailing: Text(
                      formattedDate,
                      style: TextStyle(
                        color: _isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                    isThreeLine: true,
                  );
                },
              );
            }
          }
        },
      ),
      backgroundColor: _isDark ? Colors.black87 : Colors.white,
    );
  }
}
