import 'package:flutter/material.dart';
import 'package:safeguard_v2/screens/register/index.dart';
import 'package:safeguard_v2/screens/dashboard/index.dart';
import 'package:safeguard_v2/helpers/userHelper.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controladores para os campos de texto de email e senha.
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  child:
                      Image.asset('assets/logo.png'), // Coloque seu logo aqui
                ),
                const SizedBox(height: 24.0),
                const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: emailController, // Associa o controlador.
                        decoration: const InputDecoration(
                          labelText: 'Email', // Rótulo do campo de texto.
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller:
                            passwordController, // Associa o controlador.
                        decoration: const InputDecoration(
                          labelText: 'Senha', // Rótulo do campo de texto.
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true, // Oculta o texto digitado (senha).
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          // Obtém os valores dos campos de texto.
                          String email = emailController.text;
                          String password = passwordController.text;

                          // Tenta fazer login com os dados fornecidos.
                          Map<String, dynamic>? userData =
                              await loginUser(email, password);

                          // Se o login for bem-sucedido, navega para a página de dashboard.
                          if (userData != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DashboardPage(),
                              ),
                            );
                          } else {
                            // Se o login falhar, mostra uma caixa de diálogo com mensagem de erro.
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Falha no Login'),
                                content:
                                    const Text('Email ou senha inválido(s).'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 16.0),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
                          );
                        },
                        child: const Text(
                            'Não possui uma conta? Cadastre-se aqui'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
