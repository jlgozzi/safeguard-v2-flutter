import 'package:flutter/material.dart';
import 'package:safeguard_v2/manager/sessionManager.dart';
import 'package:safeguard_v2/helpers/userHelper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SessionManager session = SessionManager();
  final _formKey = GlobalKey<FormState>();

  String? _fullName;
  String? _email;
  String? _profilePicture;
  String? _password;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _fullName = session.user?['full_name'];
    _email = session.user?['email'];
    _profilePicture = session.user?['profile_picture'];
    _setDarkMode();
  }

  void _setDarkMode() {
    final session = SessionManager();
    setState(() {
      _isDark = session.isDarkMode;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await editUser(_fullName, _email, _password);

      // Atualiza os dados do usuário no SessionManager
      session.user = await fetchUser();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
    }
  }

  Future<void> _confirmDeleteAccount() async {
    final confirmed = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDark ? Colors.black54 : Colors.white,
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza que deseja excluir sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await deleteUser();

      // Redireciona o usuário para a tela de login ou inicial
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: _isDark
                ? Colors.black54
                : const Color.fromARGB(255, 34, 193, 145),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Editar Perfil',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor:
            _isDark ? Colors.black54 : const Color.fromARGB(255, 34, 193, 145),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _fullName,
                decoration: InputDecoration(
                  labelText: 'Nome Completo',
                  labelStyle: TextStyle(
                    color: _isDark ? Colors.white : Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                style: TextStyle(color: _isDark ? Colors.white : Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome completo';
                  }
                  return null;
                },
                onSaved: (value) {
                  _fullName = value;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: _isDark ? Colors.white : Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                style: TextStyle(color: _isDark ? Colors.white : Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _profilePicture,
                decoration: InputDecoration(
                  labelText: 'URL da Foto de Perfil',
                  labelStyle: TextStyle(
                    color: _isDark ? Colors.white : Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                style: TextStyle(color: _isDark ? Colors.white : Colors.black),
                onSaved: (value) {
                  _profilePicture = value;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: TextStyle(
                    color: _isDark ? Colors.white : Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                style: TextStyle(color: _isDark ? Colors.white : Colors.black),
                obscureText: true,
                onSaved: (value) {
                  _password = value;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isDark
                      ? Colors.tealAccent
                      : const Color.fromARGB(255, 33, 222, 193),
                ),
                child: const Text('Salvar'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _confirmDeleteAccount,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Excluir Conta',
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: _isDark ? Colors.black87 : Colors.white,
    );
  }
}
