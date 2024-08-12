import 'package:flutter/material.dart';

class PasswordsPage extends StatefulWidget {
  const PasswordsPage({super.key});

  @override
  _PasswordsPageState createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passwords'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedFilter,
              items: <String>[
                'All',
                'Accounts',
                'Alphabetical',
                'Recently Modified'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                  // Adicione lógica para filtrar senhas
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Substitua com o número real de senhas
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: const Text('{{account_name}}'),
                      subtitle: const Text('**********'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Adicione a lógica de edição aqui
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              // Adicione a lógica de copiar senha aqui
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
