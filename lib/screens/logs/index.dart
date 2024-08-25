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
        title: const Text('Logs'),
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
              return const Center(child: Text('No logs found.'));
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
                    ),
                    subtitle: Text(
                      '${log['description']}\nUser ID: ${log['user_id']}',
                    ),
                    trailing: Text(formattedDate),
                    isThreeLine: true,
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
