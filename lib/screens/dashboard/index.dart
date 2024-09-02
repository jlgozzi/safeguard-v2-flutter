import 'package:flutter/material.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';
import 'package:safeguard_v2/screens/accounts/index.dart';
import 'package:safeguard_v2/screens/cards/index.dart';
import 'package:safeguard_v2/screens/category/index.dart';
import 'package:safeguard_v2/screens/config/index.dart';
import 'package:safeguard_v2/screens/logs/index.dart';
import 'package:safeguard_v2/screens/password/index.dart';
import 'package:safeguard_v2/screens/user/index.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5, // Atualizado para 5 abas
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onProfileOptionSelected(String option) {
    if (option == 'Editar Perfil') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } else if (option == 'Configurações') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserConfigPage()),
      );
    } else if (option == 'Sair') {
      // Exibe um modal de confirmação antes de realizar o logout
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sair'),
            content: const Text('Você tem certeza que deseja sair?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o modal
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o modal
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Sair'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Acessa o SessionManager e obtém o nome do usuário
    final sessionManager = SessionManager();
    final fullName = sessionManager.user?['full_name'] ?? 'Usuário';

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove o botão de voltar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/vector.png', // Substitua pelo caminho da sua imagem
              height: 50,
            ),
            const SizedBox(width: 10),
            const Text(
              'Safeguard',
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  fullName, // Exibe o nome do usuário
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(width: 10),
                PopupMenuButton<String>(
                  onSelected: _onProfileOptionSelected,
                  offset: const Offset(0, 50), // Move o menu abaixo da foto
                  itemBuilder: (BuildContext context) {
                    return {'Editar Perfil', 'Configurações', 'Sair'}
                        .map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                  child: const CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/profile.jpg'), // Caminho para a imagem do perfil
                    radius: 25,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'Contas'),
            Tab(text: 'Cartões'),
            Tab(text: 'Categorias'),
            Tab(text: 'Senhas'),
            Tab(text: 'Histórico'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AccountsPage(),
          CardsPage(),
          CategoriesPage(),
          PasswordsPage(),
          LogsPage(),
        ],
      ),
    );
  }
}
