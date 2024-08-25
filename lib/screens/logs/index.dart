import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safeguard_v2/helpers/logHelper.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});

  @override
  _LogsPageState createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  late List<dynamic> _logs; // Logs como uma lista síncrona.

  @override
  void initState() {
    super.initState();
    _logs = SessionManager().logs; // Carregar logs diretamente.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
      ),
      body: _logs.isEmpty
          ? const Center(
              child: Text('No logs found.')) // Verificação de lista vazia.
          : ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                final createdAt =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(log['created_at']);

                return ListTile(
                  title: Text(
                      '${log['action']} on ${log['table_name']} [ID: ${log['record_id']}]'),
                  subtitle:
                      Text('${log['description']}\nUser ID: ${log['user_id']}'),
                  trailing: Text(createdAt),
                  isThreeLine: true,
                );
              },
            ),
    );
  }
}
