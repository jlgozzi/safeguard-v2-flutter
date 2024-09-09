import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necessário para copiar o texto para a área de transferência
import 'package:safeguard_v2/helpers/cardHelper.dart';
import 'package:safeguard_v2/helpers/passwordsHelper.dart';
import 'package:safeguard_v2/helpers/accountHelper.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  _CardsPageState createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  List<dynamic> _cards = [];
  List<dynamic> _passwords = [];
  List<dynamic> _accounts = [];
  bool _isDark = false; // Inicializa com falso

  @override
  void initState() {
    super.initState();
    _fetchCards();
    _loadPasswordsFromSession();
    _loadAccountsFromSession();
    _setDarkMode(); // Configura o modo escuro ao iniciar
  }

  Future<void> _fetchCards() async {
    final cards = await fetchCards();
    setState(() {
      _cards = cards;
    });
  }

  void _loadPasswordsFromSession() {
    setState(() {
      final session = SessionManager();
      _passwords = session.passwords ?? [];
    });
  }

  void _loadAccountsFromSession() {
    setState(() {
      final session = SessionManager();
      _accounts = session.accounts ?? [];
    });
  }

  void _setDarkMode() {
    final session = SessionManager();
    setState(() {
      _isDark =
          session.isDarkMode; // Atualiza o valor com o tema do SessionManager
    });
  }

  Future<void> _addCard(String number, String code, String dueDate,
      int? passwordId, int? accountId) async {
    await addCard(number, code, dueDate, passwordId, accountId);
    _fetchCards();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cartão adicionado com sucesso!')));
  }

  Future<void> _editCard(int id, String number, String code, String dueDate,
      int? passwordId, int? accountId) async {
    await editCard(id, number, code, dueDate, passwordId, accountId);
    _fetchCards();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cartão editado com sucesso!')));
  }

  Future<void> _deleteCard(int id) async {
    await deleteCard(id);
    _fetchCards();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cartão excluído com sucesso!')));
  }

  void _copyCardNumber(String number) {
    Clipboard.setData(ClipboardData(text: number));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Número do cartão copiado!')));
  }

  void _showAddEditDialog({
    int? id,
    String? number,
    String? code,
    String? dueDate,
    int? selectedPasswordId,
    int? selectedAccountId,
  }) {
    final numberController = TextEditingController(text: number);
    final codeController = TextEditingController(text: code);
    final dueDateController = TextEditingController(text: dueDate);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(id == null ? 'Adicionar Cartão' : 'Editar Cartão'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: numberController,
                decoration: InputDecoration(
                  labelText: 'Número do Cartão',
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
              TextField(
                controller: dueDateController,
                decoration: InputDecoration(
                  labelText: 'Data de Vencimento',
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
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: selectedAccountId,
                items: _accounts.map((account) {
                  return DropdownMenuItem<int>(
                    value: account['id'],
                    child: Text(account['description']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedAccountId = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Conta',
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
                if (numberController.text.isNotEmpty &&
                    codeController.text.isNotEmpty) {
                  if (id == null) {
                    _addCard(
                        numberController.text,
                        codeController.text,
                        dueDateController.text,
                        selectedPasswordId,
                        selectedAccountId);
                  } else {
                    _editCard(
                        id,
                        numberController.text,
                        codeController.text,
                        dueDateController.text,
                        selectedPasswordId,
                        selectedAccountId);
                  }
                  Navigator.of(ctx).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor, preencha todos os campos.')),
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
          content: const Text('Tem certeza que deseja excluir este cartão?'),
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
                _deleteCard(id);
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
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.symmetric(
              vertical: 8.0, horizontal: 16.0), // Padding maior
          decoration: BoxDecoration(
            color: Colors.black54, // Cor de fundo
            borderRadius: BorderRadius.circular(20), // Borda arredondada
          ),
          child: const Text(
            'Gerenciamento de Cartões',
            style: TextStyle(
              color: Colors.white, // Cor do texto
              fontWeight: FontWeight.bold, // Negrito
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 34, 193, 145),
      ),
      body: _cards.isEmpty
          ? Center(
              child: Text(
                'Nenhum cartão encontrado.',
                style: TextStyle(
                  fontSize: 18,
                  color: _isDark ? Colors.white : Colors.black, // Cor do texto
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _cards.length,
              itemBuilder: (ctx, index) {
                final card = _cards[index];
                return Card(
                  color: _isDark
                      ? const Color.fromARGB(255, 30, 30, 30)
                      : Colors.white, // Cor do cartão
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    title: Text(
                      'Cartão: ${card['number']}',
                      style: TextStyle(
                        color: _isDark
                            ? Colors.white
                            : Colors.black, // Cor do texto
                      ),
                    ),
                    subtitle: Text(
                      'Código: ${card['code']} | Vencimento: ${card['due_date']}',
                      style: TextStyle(
                        color: _isDark
                            ? Colors.white70
                            : Colors.black87, // Cor do texto
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.green),
                          onPressed: () {
                            _copyCardNumber(card['number']);
                          },
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () {
                            _showAddEditDialog(
                              id: card['id'],
                              number: card['number'],
                              code: card['code'],
                              dueDate: card['due_date'],
                              selectedPasswordId: card['password_id'],
                              selectedAccountId: card['account_id'],
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(card['id']);
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
        backgroundColor: const Color.fromARGB(255, 18, 191, 136),
        child: const Icon(Icons.add),
      ),
      backgroundColor: _isDark ? Colors.black87 : Colors.white, // Cor de fundo
    );
  }
}
