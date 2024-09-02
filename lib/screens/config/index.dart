import 'package:flutter/material.dart';
import 'package:safeguard_v2/helpers/configHelper.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';
import 'package:safeguard_v2/screens/dashboard/index.dart';

class UserConfigPage extends StatefulWidget {
  const UserConfigPage({super.key});

  @override
  _UserConfigPageState createState() => _UserConfigPageState();
}

class _UserConfigPageState extends State<UserConfigPage> {
  bool? isDark;
  bool? isPassVisible;
  bool? isNameVisible;

  @override
  void initState() {
    super.initState();
    _loadUserConfigs();
  }

  Future<void> _loadUserConfigs() async {
    final session = SessionManager();
    final userConfigs = session.userConfig;

    if (userConfigs != null) {
      setState(() {
        isDark = userConfigs['is_dark'];
        isPassVisible = userConfigs['is_pass_visible'];
        isNameVisible = userConfigs['is_name_visible'];
      });
    }
  }

  Future<void> _saveUserConfigs() async {
    final session = SessionManager();
    await updateUserConfigs(isDark!, isPassVisible!, isNameVisible!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configurações salvas com sucesso!')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isDark == null || isPassVisible == null || isNameVisible == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações do Usuário'),
        backgroundColor:
            isDark! ? Colors.black54 : const Color.fromARGB(255, 34, 193, 145),
      ),
      body: Container(
        color: isDark! ? Colors.black87 : Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(
                'Modo Escuro',
                style: TextStyle(color: isDark! ? Colors.white : Colors.black),
              ),
              value: isDark!,
              activeColor: const Color.fromARGB(255, 34, 193, 145),
              onChanged: (value) {
                setState(() {
                  isDark = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(
                'Exibir Senhas',
                style: TextStyle(color: isDark! ? Colors.white : Colors.black),
              ),
              value: isPassVisible!,
              activeColor: const Color.fromARGB(255, 34, 193, 145),
              onChanged: (value) {
                setState(() {
                  isPassVisible = value;
                });
              },
            ),
            SwitchListTile(
              title: Text(
                'Exibir Nome',
                style: TextStyle(color: isDark! ? Colors.white : Colors.black),
              ),
              value: isNameVisible!,
              activeColor: const Color.fromARGB(255, 34, 193, 145),
              onChanged: (value) {
                setState(() {
                  isNameVisible = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserConfigs,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark!
                    ? Colors.tealAccent
                    : const Color.fromARGB(255, 33, 222, 193),
              ),
              child: const Text('Salvar Configurações'),
            ),
          ],
        ),
      ),
    );
  }
}
