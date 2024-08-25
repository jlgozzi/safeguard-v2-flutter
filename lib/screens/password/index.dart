import 'package:flutter/material.dart';
import 'package:safeguard_v2/helpers/categoryHelper.dart';
import 'package:safeguard_v2/helpers/dbHelper.dart';
import 'package:safeguard_v2/helpers/passwordsHelper.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';

class PasswordsPage extends StatefulWidget {
  const PasswordsPage({super.key});

  @override
  _PasswordsPageState createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  List<dynamic> _passwords = [];
  List<dynamic> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchPasswords();
    _loadCategoriesFromSession();
  }

  Future<void> _fetchPasswords() async {
    final passwords = await fetchPasswords();
    setState(() {
      _passwords = passwords;
    });
  }

  void _loadCategoriesFromSession() {
    final session = SessionManager();
    setState(() {
      _categories = session.categories;
    });
  }

  Future<void> _addPassword(String description, String code) async {
    await addPassword(description, code);
    _fetchPasswords();
  }

  Future<void> _editPassword(int id, String description, String code) async {
    await editPassword(id, description, code);
    _fetchPasswords();
  }

  Future<void> _deletePassword(int id) async {
    await deletePassword(id);
    _fetchPasswords();
  }

  void _showAddEditDialog({int? id, String? description, String? code}) {
    final descriptionController = TextEditingController(text: description);
    final codeController = TextEditingController(text: code);

    String? selectedCategoryId;
    if (_categories.isNotEmpty) {
      selectedCategoryId = _categories[0]['id'].toString();
    }

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
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  labelText: 'Código',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _categories.isNotEmpty
                  ? DropdownButtonFormField<String>(
                      value: selectedCategoryId,
                      items: _categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category['id'].toString(),
                          child: Text(category['description']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategoryId = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Categoria',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    )
                  : const CircularProgressIndicator(),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            ElevatedButton(
              child: Text(id == null ? 'Adicionar' : 'Salvar'),
              onPressed: () {
                if (selectedCategoryId != null) {
                  if (id == null) {
                    _addPassword(
                        descriptionController.text, codeController.text);
                  } else {
                    _editPassword(
                        id, descriptionController.text, codeController.text);
                  }
                  Navigator.of(ctx).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor, selecione uma categoria.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja excluir esta senha?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 18, 191, 136),
              ),
              onPressed: () {
                _deletePassword(id);
                Navigator.of(ctx).pop();
              },
              child: const Text('Excluir'),
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
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 151, 252, 224),
      ),
      body: _passwords.isEmpty
          ? const Center(
              child: Text('Nenhuma senha encontrada.',
                  style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _passwords.length,
              itemBuilder: (ctx, index) {
                final password = _passwords[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    title: Text(
                      password['description'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(password['code']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Color.fromARGB(255, 67, 67, 67)),
                          onPressed: () {
                            _showAddEditDialog(
                              id: password['id'],
                              description: password['description'],
                              code: password['code'],
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Color.fromARGB(255, 199, 34, 22)),
                          onPressed: () {
                            _showDeleteConfirmationDialog(password['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditDialog();
        },
        backgroundColor: const Color.fromARGB(255, 33, 222, 193),
        child: const Icon(Icons.add),
      ),
    );
  }
}
