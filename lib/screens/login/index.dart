import 'package:flutter/material.dart';
import 'package:safeguard_v2/helpers/userHelper.dart';
import 'package:safeguard_v2/screens/register/index.dart';
import 'package:safeguard_v2/screens/dashboard/index.dart';
import 'package:safeguard_v2/helpers/dbHelper.dart'; // Importe o userHelper

// Define uma página de login, que é um widget stateless.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controladores para os campos de texto de email e senha.
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'), // Título da AppBar.
      ),
      // Preenche o corpo da Scaffold com um padding de 16 pixels.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Organiza os widgets em uma coluna vertical centrada.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Campo de texto para entrada do email.
            TextField(
              controller: emailController, // Associa o controlador.
              decoration: const InputDecoration(
                labelText: 'Email', // Rótulo do campo de texto.
              ),
            ),
            const SizedBox(height: 16.0), // Espaçamento vertical.
            // Campo de texto para entrada da senha.
            TextField(
              controller: passwordController, // Associa o controlador.
              decoration: const InputDecoration(
                labelText: 'Senha', // Rótulo do campo de texto.
              ),
              obscureText: true, // Oculta o texto digitado (senha).
            ),
            const SizedBox(height: 24.0), // Espaçamento vertical.
            // Botão de login.
            ElevatedButton(
              onPressed: () async {
                // Obtém os valores dos campos de texto.
                String email = emailController.text;
                String password = passwordController.text;

                // Tenta fazer login com os dados fornecidos.
                Map<String, dynamic>? userData =
                    await loginUser(email, password);

                print(userData); // Imprime os dados do usuário para depuração.

                // Se o login for bem-sucedido, navega para a página de dashboard.
                if (userData != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardPage(userData: userData),
                    ),
                  );
                } else {
                  // Se o login falhar, mostra uma caixa de diálogo com mensagem de erro.
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                          'Falha no Login'), // Título da caixa de diálogo.
                      content: const Text(
                          'Email ou senha inválido(s).'), // Conteúdo da mensagem.
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Fecha a caixa de diálogo.
                          },
                          child: const Text('OK'), // Texto do botão.
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Login'), // Texto do botão de login.
            ),
            const SizedBox(height: 16.0), // Espaçamento vertical.
            // Botão para alterar para a página de registro.
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text(
                  'Não possui uma conta? Cadastre-se aqui'), // Texto do botão.
            ),
          ],
        ),
      ),
    );
  }
}
