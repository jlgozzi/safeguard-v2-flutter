import 'package:flutter/material.dart';
import 'package:safeguard_v2/helpers/configHelper.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    if (isDark == null || isPassVisible == null || isNameVisible == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações do Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Modo Escuro'),
              value: isDark!,
              onChanged: (value) {
                setState(() {
                  isDark = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Exibir Senhas'),
              value: isPassVisible!,
              onChanged: (value) {
                setState(() {
                  isPassVisible = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Exibir Nome'),
              value: isNameVisible!,
              onChanged: (value) {
                setState(() {
                  isNameVisible = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserConfigs,
              child: const Text('Salvar Configurações'),
            ),
          ],
        ),
      ),
    );
  }
}
