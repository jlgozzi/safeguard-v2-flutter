import 'package:flutter/material.dart';
import 'package:safeguard_v2/screens/accounts/index.dart';
import 'package:safeguard_v2/screens/cards/index.dart';
import 'package:safeguard_v2/screens/category/index.dart';
// import 'package:safeguard_v2/screens/config/index.dart';
import 'package:safeguard_v2/screens/password/index.dart';
import 'package:safeguard_v2/screens/user_config/index.dart';
import 'package:safeguard_v2/screens/logs/index.dart';

class DashboardPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const DashboardPage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safeguard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header com imagem, nome e email do usuário
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.person, color: Colors.grey, size: 40),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData['full_name'] ?? 'Nome do Usuário',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userData['email'] ?? 'email@exemplo.com',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Box com botões menores
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Dois botões por linha
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardButton(
                    context,
                    icon: Icons.credit_card,
                    label: 'Cartões',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CardsPage()),
                      );
                    },
                  ),
                  _buildDashboardButton(
                    context,
                    icon: Icons.account_box,
                    label: 'Contas',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AccountsPage()),
                      );
                    },
                  ),
                  _buildDashboardButton(
                    context,
                    icon: Icons.category,
                    label: 'Categorias',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CategoriesPage()),
                      );
                    },
                  ),
                  _buildDashboardButton(
                    context,
                    icon: Icons.vpn_key,
                    label: 'Senhas',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PasswordsPage()),
                      );
                    },
                  ),
                  _buildDashboardButton(
                    context,
                    icon: Icons.history,
                    label: 'Histórico',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LogsPage()),
                      );
                    },
                  ),
                  _buildDashboardButton(
                    context,
                    icon: Icons.settings,
                    label: 'Configurações',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserConfigPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
