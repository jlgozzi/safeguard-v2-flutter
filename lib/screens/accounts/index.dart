import 'package:flutter/material.dart';
import 'package:safeguard_v2/helpers/accountHelper.dart';
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
  List<bool> _isPasswordVisible = []; // Controla a visibilidade das senhas
  bool _isDark = false; // Variável de tema

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
    _loadCategoriesAndPasswordsFromSession();
    _setDarkMode();
  }

  void _setDarkMode() {
    final session = SessionManager();
    setState(() {
      _isDark =
          session.isDarkMode; // Atualiza o valor com o tema do SessionManager
    });
  }

  Future<void> _fetchAccounts() async {
    final accounts = await fetchAccounts();
    setState(() {
      _accounts = accounts;
      _isPasswordVisible = List<bool>.filled(accounts.length, false);
    });
  }

  void _loadCategoriesAndPasswordsFromSession() {
    setState(() {
      final session = SessionManager();
      _categories = session.categories ?? [];
      _passwords = session.passwords ?? [];
    });
  }

  Future<void> _addAccount(
      String description, String? url, int? categoryId, int? passwordId) async {
    await addAccount(description, url, categoryId, passwordId);
    _fetchAccounts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Conta adicionada com sucesso!')),
    );
  }

  Future<void> _editAccount(int id, String description, String? url,
      int? categoryId, int? passwordId, bool isVisible) async {
    await editAccount(id, description, url, categoryId, passwordId, isVisible);
    _fetchAccounts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Conta editada com sucesso!')),
    );
  }

  Future<void> _deleteAccount(int id) async {
    await deleteAccount(id);
    _fetchAccounts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Conta excluída com sucesso!')),
    );
  }

  void _showAddEditDialog({
    int? id,
    String? description,
    String? url,
    int? selectedCategoryId,
    int? selectedPasswordId,
    bool isVisible = true,
  }) {
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
          backgroundColor: Colors.white,
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
      backgroundColor: _isDark
          ? Colors.black // Cor de fundo para modo escuro
          : const Color.fromARGB(
              255, 245, 245, 245), // Cor de fundo para modo claro
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Gerenciamento de Contas',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 34, 193, 145),
      ),
      body: _accounts.isEmpty
          ? Center(
              child: Text(
                'Nenhuma conta encontrada.',
                style: TextStyle(
                  fontSize: 18,
                  color: _isDark ? Colors.white : Colors.black, // Cor do texto
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _accounts.length,
              itemBuilder: (ctx, index) {
                final account = _accounts[index];
                return Card(
                  color: _isDark
                      ? const Color.fromARGB(255, 30, 30, 30)
                      : Colors.white, // Cor do cartão
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account['description'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        if (account['url'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              account['url'],
                              style: TextStyle(
                                color:
                                    _isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _isPasswordVisible[index]
                                    ? account['password_value'] ?? ''
                                    : '***',
                                style: TextStyle(
                                  color:
                                      _isDark ? Colors.white70 : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _isPasswordVisible[index]
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible[index] =
                                            !_isPasswordVisible[index];
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: () {
                                      _showAddEditDialog(
                                        id: account['id'],
                                        description: account['description'],
                                        url: account['url'],
                                        selectedCategoryId:
                                            account['category_id'],
                                        selectedPasswordId:
                                            account['password_id'],
                                        isVisible: _isPasswordVisible[index],
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          account['id']);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
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
        backgroundColor: _isDark
            ? const Color.fromARGB(255, 34, 193, 145)
            : const Color.fromARGB(255, 18, 191, 136),
        child: const Icon(Icons.add),
      ),
    );
  }
}
