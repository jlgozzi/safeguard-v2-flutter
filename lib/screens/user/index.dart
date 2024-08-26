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

  @override
  void initState() {
    super.initState();
    _fullName = session.user?['full_name'];
    _email = session.user?['email'];
    _profilePicture = session.user?['profile_picture'];
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
        title: const Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _fullName,
                decoration: const InputDecoration(labelText: 'Nome Completo'),
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
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
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
              TextFormField(
                initialValue: _profilePicture,
                decoration:
                    const InputDecoration(labelText: 'URL da Foto de Perfil'),
                onSaved: (value) {
                  _profilePicture = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                onSaved: (value) {
                  _password = value;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Salvar'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _confirmDeleteAccount,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Excluir Conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
