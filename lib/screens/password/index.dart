import 'package:flutter/material.dart';
import 'package:safeguard_v2/helpers/categoryHelper.dart';
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
  bool _isDark = SessionManager().isDarkMode;

  @override
  void initState() {
    super.initState();
    _fetchPasswords();
    _loadCategoriesFromSession();
    _setDarkMode();
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

  void _setDarkMode() {
    final session = SessionManager();
    setState(() {
      _isDark = session.isDarkMode;
    });
  }

  Future<void> _addPassword(
      String description, String code, String categoryId) async {
    await addPassword(description, code);
    _fetchPasswords();
  }

  Future<void> _editPassword(
      int id, String description, String code, String categoryId) async {
    await editPassword(id, description, code);
    _fetchPasswords();
  }

  Future<void> _deletePassword(int id) async {
    await deletePassword(id);
    _fetchPasswords();
  }

  void _showAddEditDialog(
      {int? id, String? description, String? code, String? categoryId}) {
    final descriptionController = TextEditingController(text: description);
    final codeController = TextEditingController(text: code);
    String? selectedCategoryId = categoryId ??
        (_categories.isNotEmpty ? _categories[0]['id'].toString() : null);

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
                if (selectedCategoryId != null &&
                    descriptionController.text.isNotEmpty &&
                    codeController.text.isNotEmpty) {
                  if (id == null) {
                    _addPassword(descriptionController.text,
                        codeController.text, selectedCategoryId!);
                  } else {
                    _editPassword(id, descriptionController.text,
                        codeController.text, selectedCategoryId!);
                  }
                  Navigator.of(ctx).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Por favor, preencha todos os campos e selecione uma categoria.')),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Senha excluída com sucesso!'),
                  ),
                );
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
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Minhas senhas',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 34, 193, 145),
      ),
      body: _passwords.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma senha encontrada.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _passwords.length,
              itemBuilder: (ctx, index) {
                final password = _passwords[index];
                return Card(
                  color: _isDark
                      ? const Color.fromARGB(255, 30, 30, 30)
                      : Colors.white,
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    title: Text(
                      password['description'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      password['code'],
                      style: TextStyle(
                        color: _isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
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
                              categoryId: password['categoryId'],
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
      backgroundColor: _isDark ? Colors.black87 : Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditDialog();
        },
        backgroundColor: const Color.fromARGB(255, 18, 191, 136),
        child: const Icon(Icons.add),
      ),
    );
  }
}
