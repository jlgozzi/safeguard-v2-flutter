import 'package:flutter/material.dart';
import 'package:safeguard_v2/helpers/dbHelper.dart'; // Importe o dbHelper que lida com o banco de dados

// Define a página de senhas como um StatefulWidget, permitindo que o estado mude durante a execução
class PasswordsPage extends StatefulWidget {
  const PasswordsPage({super.key});

  @override
  _PasswordsPageState createState() => _PasswordsPageState();
}

// Classe que mantém o estado da página de senhas
class _PasswordsPageState extends State<PasswordsPage> {
  // Lista que contém as senhas
  List<dynamic> _passwords = [];

  @override
  void initState() {
    super.initState();
    _fetchPasswords(); // Chama a função para carregar as senhas quando a página é inicializada
  }

  // Função assíncrona para buscar as senhas do banco de dados
  Future<void> _fetchPasswords() async {
    final passwords =
        await fetchPasswords(); // Busca as senhas no banco de dados
    setState(() {
      _passwords = passwords; // Atualiza o estado com as senhas obtidas
    });
  }

  // Função assíncrona para adicionar uma nova senha
  Future<void> _addPassword(String description, String code) async {
    await addPassword(description, code); // Adiciona a senha ao banco de dados
    _fetchPasswords(); // Recarrega a lista de senhas após adicionar uma nova
  }

  // Função assíncrona para editar uma senha existente
  Future<void> _editPassword(int id, String description, String code) async {
    await editPassword(
        id, description, code); // Edita a senha no banco de dados
    _fetchPasswords(); // Recarrega a lista de senhas após a edição
  }

  // Função assíncrona para deletar uma senha
  Future<void> _deletePassword(int id) async {
    await deletePassword(id); // Deleta a senha do banco de dados
    _fetchPasswords(); // Recarrega a lista de senhas após a exclusão
  }

  // Função para mostrar o diálogo de adicionar/editar senha
  void _showAddEditDialog({int? id, String? description, String? code}) {
    // Controladores para capturar o texto inserido pelo usuário
    final descriptionController = TextEditingController(text: description);
    final codeController = TextEditingController(text: code);

    // Mostra o diálogo usando showDialog
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(id == null
              ? 'Adicionar Senha'
              : 'Editar Senha'), // Define o título do diálogo
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo de texto para a descrição da senha
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(
                  height: 10), // Espaçamento entre os campos de texto
              // Campo de texto para o código da senha
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  labelText: 'Código',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
          // Botões de ações no diálogo
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop(); // Fecha o diálogo ao cancelar
              },
            ),
            ElevatedButton(
              child: Text(id == null ? 'Adicionar' : 'Salvar'),
              onPressed: () {
                if (id == null) {
                  _addPassword(descriptionController.text,
                      codeController.text); // Adiciona uma nova senha
                } else {
                  _editPassword(id, descriptionController.text,
                      codeController.text); // Edita a senha existente
                }
                Navigator.of(ctx).pop(); // Fecha o diálogo após a ação
              },
            ),
          ],
        );
      },
    );
  }

  // Função para mostrar o diálogo de confirmação de exclusão
  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text(
              'Confirmar Exclusão'), // Título do diálogo de confirmação
          content: const Text('Tem certeza que deseja excluir esta senha?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop(); // Fecha o diálogo ao cancelar
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // Estilo do botão de exclusão
                backgroundColor: const Color.fromARGB(255, 18, 191, 136),
              ),
              onPressed: () {
                _deletePassword(id); // Deleta a senha ao confirmar
                Navigator.of(ctx).pop(); // Fecha o diálogo após a exclusão
              },
              child: const Text('Excluir'), // Texto do botão de exclusão
            ),
          ],
        );
      },
    );
  }

  // Método build para desenhar a interface do usuário da página
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciamento de Senhas'),
        centerTitle: true,
        backgroundColor:
            const Color.fromARGB(255, 151, 252, 224), // Cor do AppBar
      ),
      // Corpo da página. Mostra uma mensagem se a lista de senhas estiver vazia,
      // caso contrário, mostra uma lista de senhas
      body: _passwords.isEmpty
          ? const Center(
              child: Text('Nenhuma senha encontrada.',
                  style:
                      TextStyle(fontSize: 18))) // Mensagem quando não há senhas
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _passwords.length, // Número de senhas na lista
              itemBuilder: (ctx, index) {
                final password = _passwords[index]; // Cada senha na lista
                return Card(
                  elevation: 5, // Elevação do Card para dar sombra
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // Borda arredondada do Card
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    title: Text(
                      password['description'], // Descrição da senha
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(password['code']), // Código da senha
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botão de editar senha
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Color.fromARGB(255, 67, 67, 67)),
                          onPressed: () {
                            _showAddEditDialog(
                              id: password['id'], // ID da senha
                              description:
                                  password['description'], // Descrição da senha
                              code: password['code'], // Código da senha
                            );
                          },
                        ),
                        // Botão de deletar senha
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Color.fromARGB(255, 199, 34, 22)),
                          onPressed: () {
                            _showDeleteConfirmationDialog(password[
                                'id']); // Mostra diálogo de confirmação de exclusão
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
          _showAddEditDialog(); // Mostra o diálogo de adicionar senha
        },
        backgroundColor: const Color.fromARGB(255, 33, 222, 193),
        child: const Icon(Icons.add), // Ícone do botão flutuante
      ),
    );
  }
}
