import 'package:flutter/material.dart';
import 'package:safeguard_v2/helpers/accountHelper.dart';
import 'package:safeguard_v2/helpers/passwordsHelper.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  List<dynamic> _accounts = [];
  List<dynamic> _categories = [];
  List<dynamic> _passwords = [];

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
    _loadCategoriesAndPasswordsFromSession();
  }

  Future<void> _fetchAccounts() async {
    final accounts = await fetchAccounts();
    setState(() {
      _accounts = accounts;
    });
  }

  void _loadCategoriesAndPasswordsFromSession() async {
    setState(() {
      // Carregamento de dados assíncronos dentro de setState
      final session = SessionManager();
      _categories = session.categories ?? [];
      _passwords = session.passwords ?? [];
    });
  }

  Future<void> _addAccount(
      String description, String? url, int? categoryId, int? passwordId) async {
    await addAccount(description, url, categoryId, passwordId);
    _fetchAccounts();
  }

  Future<void> _editAccount(int id, String description, String? url,
      int? categoryId, int? passwordId, bool isVisible) async {
    await editAccount(id, description, url, categoryId, passwordId, isVisible);
    _fetchAccounts();
  }

  Future<void> _deleteAccount(int id) async {
    await deleteAccount(id);
    _fetchAccounts();
  }

  void _showAddEditDialog(
      {int? id,
      String? description,
      String? url,
      int? selectedCategoryId,
      int? selectedPasswordId,
      bool isVisible = true}) {
    final descriptionController = TextEditingController(text: description);
    final urlController = TextEditingController(text: url);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(id == null ? 'Adicionar Conta' : 'Editar Conta'),
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
                controller: urlController,
                decoration: InputDecoration(
                  labelText: 'URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: selectedCategoryId,
                items: _categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category['id'],
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
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: selectedPasswordId,
                items: _passwords.map((password) {
                  return DropdownMenuItem<int>(
                    value: password['id'],
                    child: Text(password['description']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPasswordId = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
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
            ElevatedButton(
              child: Text(id == null ? 'Adicionar' : 'Salvar'),
              onPressed: () {
                if (selectedCategoryId != null) {
                  if (id == null) {
                    _addAccount(descriptionController.text, urlController.text,
                        selectedCategoryId!, selectedPasswordId);
                  } else {
                    _editAccount(
                        id,
                        descriptionController.text,
                        urlController.text,
                        selectedCategoryId!,
                        selectedPasswordId,
                        isVisible);
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
          content: const Text('Tem certeza que deseja excluir esta conta?'),
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
                _deleteAccount(id);
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
        title: const Text('Gerenciamento de Contas'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 151, 252, 224),
      ),
      body: _accounts.isEmpty
          ? const Center(
              child: Text('Nenhuma conta encontrada.',
                  style: TextStyle(fontSize: 18)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _accounts.length,
              itemBuilder: (ctx, index) {
                final account = _accounts[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    title: Text(
                      account['description'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                        account['url'] != null ? Text(account['url']) : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Color.fromARGB(255, 67, 67, 67)),
                          onPressed: () {
                            _showAddEditDialog(
                              id: account['id'],
                              description: account['description'],
                              url: account['url'],
                              selectedCategoryId: account['category_id'],
                              selectedPasswordId: account['password_id'],
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Color.fromARGB(255, 199, 34, 22)),
                          onPressed: () {
                            _showDeleteConfirmationDialog(account['id']);
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
