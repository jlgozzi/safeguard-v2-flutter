import 'package:flutter/material.dart';
import 'package:safeguard_v2/helpers/categoryHelper.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<dynamic> _categories = [];
  bool _isDark = SessionManager().isDarkMode; // Variável para controle do tema

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _setDarkMode();
  }

  Future<void> _fetchCategories() async {
    final categories = await fetchCategories();
    setState(() {
      _categories = categories;
    });
  }

  void _setDarkMode() {
    final session = SessionManager();
    setState(() {
      _isDark = session.isDarkMode;
    });
  }

  Future<void> _addCategory(String description) async {
    await addCategory(description);
    _fetchCategories();
  }

  Future<void> _editCategory(int id, String description) async {
    await editCategory(id, description);
    _fetchCategories();
  }

  Future<void> _deleteCategory(int id) async {
    await deleteCategory(id);
    _fetchCategories();
  }

  void _showAddEditDialog({int? id, String? description}) {
    final descriptionController = TextEditingController(text: description);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(id == null ? 'Adicionar Categoria' : 'Editar Categoria'),
          content: TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Descrição',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
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
                if (descriptionController.text.isNotEmpty) {
                  if (id == null) {
                    _addCategory(descriptionController.text);
                  } else {
                    _editCategory(id, descriptionController.text);
                  }
                  Navigator.of(ctx).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, preencha a descrição.'),
                    ),
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
          content: const Text('Tem certeza que deseja excluir esta categoria?'),
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
                _deleteCategory(id);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Categoria excluída com sucesso!'),
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
            'Minhas categorias',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 34, 193, 145),
      ),
      body: _categories.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma categoria encontrada.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _categories.length,
              itemBuilder: (ctx, index) {
                final category = _categories[index];
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
                      category['description'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _isDark ? Colors.white : Colors.black,
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
                              id: category['id'],
                              description: category['description'],
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Color.fromARGB(255, 199, 34, 22)),
                          onPressed: () {
                            _showDeleteConfirmationDialog(category['id']);
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
