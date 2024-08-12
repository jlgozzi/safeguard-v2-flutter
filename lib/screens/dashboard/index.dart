import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const DashboardPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MediaQuery.of(context).size.width < 600
          ? NavigationDrawer(userData: userData)
          : null,
      appBar: MediaQuery.of(context).size.width >= 600
          ? null
          : AppBar(
              title: const Text('Dashboard'),
            ),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 600)
            NavigationDrawer(userData: userData),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DashboardContent(userData: userData),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  final Map<String, dynamic> userData;

  const NavigationDrawer({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userData['full_name'] ?? ''),
            accountEmail: Text(userData['email'] ?? ''),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('Cartões'),
            onTap: () {
              // Navigate to Cards
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text('Contas'),
            onTap: () {
              // Navigate to Accounts
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categorias'),
            onTap: () {
              // Navigate to Categories
            },
          ),
          ListTile(
            leading: const Icon(Icons.vpn_key),
            title: const Text('Senhas'),
            onTap: () {
              // Navigate to Passwords
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Histórico'),
            onTap: () {
              // Navigate to Logs
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              // Navigate to Settings
            },
          ),
        ],
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  final Map<String, dynamic> userData;

  const DashboardContent({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Olá, ${userData['full_name'] ?? ''}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                // Adicionar nova senha
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const SectionTitle(title: 'Recentes'),
        const SizedBox(height: 16),
        const RecentPasswordsList(),
        const SizedBox(height: 24),
        SectionWithAddButton(
          title: 'Cartões',
          itemCount: 3,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Cartão $index'),
              subtitle: Text('Descrição do Cartão $index'),
            );
          },
          onAddPressed: () {
            _showAddItemModal(context, 'Cartão');
          },
        ),
        ViewMoreButton(
          label: 'Ver mais',
          onPressed: () {
            // Lógica para navegar para a página de cartões
          },
        ),
        const SizedBox(height: 24),
        SectionWithAddButton(
          title: 'Contas',
          itemCount: 3,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Conta $index'),
              subtitle: Text('Descrição da Conta $index'),
            );
          },
          onAddPressed: () {
            _showAddItemModal(context, 'Conta');
          },
        ),
        ViewMoreButton(
          label: 'Ver mais',
          onPressed: () {
            // Lógica para navegar para a página de contas
          },
        ),
      ],
    );
  }

  void _showAddItemModal(BuildContext context, String itemType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar $itemType'),
          content: Text('Formulário para adicionar $itemType'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                // Lógica para adicionar o item
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class RecentPasswordsList extends StatelessWidget {
  const RecentPasswordsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) {
        return ListTile(
          title: Text('Conta $index'),
          subtitle: const Text('********'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Editar senha
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Deletar senha
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

class SectionWithAddButton extends StatelessWidget {
  final String title;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final VoidCallback onAddPressed;

  const SectionWithAddButton({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SectionTitle(title: title),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAddPressed,
            ),
          ],
        ),
        Column(
          children: List.generate(itemCount, (index) {
            return itemBuilder(context, index);
          }),
        ),
      ],
    );
  }
}

class ViewMoreButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ViewMoreButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
