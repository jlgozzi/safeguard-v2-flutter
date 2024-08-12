import 'package:flutter/material.dart';
import 'package:safeguard_v2/helpers/dbHelper.dart'; // Importe o userHelper

class PasswordsPage extends StatefulWidget {
  const PasswordsPage({super.key});

  @override
  _PasswordsPageState createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  List<dynamic> _passwords = [];

  @override
  void initState() {
    super.initState();
    _fetchPasswords(); // Carrega as senhas quando a página é inicializada
  }

  Future<void> _fetchPasswords() async {
    final passwords = await fetchPasswords();
    setState(() {
      _passwords = passwords;
    });
  }

  Future<void> _addPassword(String description, String code) async {
    await addPassword(description, code);
    _fetchPasswords(); // Recarrega a lista de senhas após adicionar uma nova
  }

  Future<void> _editPassword(int id, String description, String code) async {
    await editPassword(id, description, code);
    _fetchPasswords(); // Recarrega a lista de senhas após editar
  }

  void _showAddEditDialog({int? id, String? description, String? code}) {
    final descriptionController = TextEditingController(text: description);
    final codeController = TextEditingController(text: code);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(id == null ? 'Adicionar Senha' : 'Editar Senha'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(labelText: 'Código'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: Text(id == null ? 'Adicionar' : 'Salvar'),
              onPressed: () {
                if (id == null) {
                  _addPassword(descriptionController.text, codeController.text);
                } else {
                  _editPassword(
                      id, descriptionController.text, codeController.text);
                }
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciamento de Senhas'),
      ),
      body: _passwords.isEmpty
          ? const Center(child: Text('Nenhuma senha encontrada.'))
          : ListView.builder(
              itemCount: _passwords.length,
              itemBuilder: (ctx, index) {
                final password = _passwords[index];
                return ListTile(
                  title: Text(password['description']),
                  subtitle: Text(password['code']),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showAddEditDialog(
                        id: password['id'],
                        description: password['description'],
                        code: password['code'],
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddEditDialog();
        },
      ),
    );
  }
}
