import 'package:flutter/material.dart';
import 'package:safeguard_v2/helpers/userHelper.dart';
import 'package:safeguard_v2/screens/login/index.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isTermsAccepted = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? value) {
    const pattern = r'^[^@]+@[^@]+\.[^@]+$';
    final regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    } else if (!regExp.hasMatch(value)) {
      return 'Insira um email válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    const pattern = r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$';
    final regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    } else if (!regExp.hasMatch(value)) {
      return 'A senha deve ter no mínimo 8 caracteres, incluindo 1 número, 1 letra maiúscula e 1 caractere especial';
    }
    return null;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sucesso'),
          content: const Text('Usuário registrado com sucesso!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Termos de Acesso'),
          content: const SingleChildScrollView(
            child: Text(
              'Termos de Uso do Safeguard - Sistema de Gerenciamento de Senhas\n\n'
              '1. Aceitação dos Termos\n\n'
              'Ao acessar ou utilizar o Safeguard - Sistema de Gerenciamento de Senhas, '
              'você concorda em cumprir e estar sujeito aos termos e condições abaixo especificados. '
              'Se você não concordar com estes termos, não utilize o sistema.\n\n'
              '2. Descrição do Serviço\n\n'
              'O Safeguard é um sistema de gerenciamento de senhas que permite aos usuários armazenar, '
              'organizar e gerenciar suas senhas e informações confidenciais de forma segura. O sistema '
              'é projetado como um aplicativo desktop monolítico utilizando a tecnologia Flutter para a '
              'interface do usuário e PostgreSQL como banco de dados.\n\n'
              '3. Uso Permitido\n\n'
              'Você concorda em utilizar o Safeguard apenas para fins legais e de acordo com estes termos. '
              'Você não deve utilizar o sistema para qualquer atividade ilícita ou que possa comprometer a '
              'segurança ou a integridade do sistema ou de seus dados.\n\n'
              '4. Segurança de Dados\n\n'
              'O Safeguard implementa medidas de segurança rigorosas para proteger suas informações pessoais '
              'e senhas. No entanto, você é responsável por manter a confidencialidade de suas credenciais de '
              'acesso e deve notificar imediatamente qualquer uso não autorizado de sua conta.\n\n'
              '5. Limitação de Responsabilidade\n\n'
              'O Safeguard é um projeto acadêmico e é fornecido "como está". Não garantimos que o sistema estará '
              'livre de erros, bugs ou falhas. Em nenhuma circunstância, os desenvolvedores serão responsáveis por '
              'qualquer dano direto, indireto, incidental, especial ou consequencial decorrente do uso ou da incapacidade '
              'de usar o sistema.\n\n'
              '6. Propriedade Intelectual\n\n'
              'Todos os direitos, títulos e interesses relacionados ao Safeguard, incluindo, mas não se limitando a, software, '
              'textos, gráficos, e logos são propriedade de João Lucas Gozzi. Qualquer uso não autorizado dos materiais pode '
              'violar leis de direitos autorais, marcas registradas e outras legislações.\n\n'
              '7. Atualizações e Modificações\n\n'
              'Reservamo-nos o direito de modificar ou descontinuar, temporária ou permanentemente, o Safeguard ou qualquer '
              'parte dele, com ou sem aviso prévio. Também podemos revisar estes termos de uso a qualquer momento e é sua '
              'responsabilidade revisar regularmente os termos atualizados.\n\n'
              '8. Conformidade com a LGPD\n\n'
              'O Safeguard compromete-se a seguir as diretrizes da Lei Geral de Proteção de Dados (LGPD) do Brasil. Todas as '
              'informações pessoais coletadas e armazenadas pelo sistema serão tratadas de acordo com as disposições da LGPD, '
              'garantindo que seus dados sejam protegidos e utilizados de maneira transparente e segura.\n\n'
              '9. Termos Gerais\n\n'
              'Estes termos constituem o acordo integral entre você e os desenvolvedores do Safeguard em relação ao uso do sistema. '
              'Se qualquer disposição destes termos for considerada inválida por um tribunal competente, a invalidade de tal disposição '
              'não afetará a validade das demais disposições, que permanecerão em pleno vigor e efeito.\n\n'
              '10. Contato\n\n'
              'Se você tiver qualquer dúvida sobre estes termos de uso, entre em contato com João Lucas Gozzi.\n\n'
              'Este Termo de Uso foi desenvolvido para o projeto acadêmico "Safeguard - Sistema de Gerenciamento de Senhas" e deve ser '
              'utilizado exclusivamente para fins educacionais.',
              style: TextStyle(fontSize: 14),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
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
        backgroundColor: const Color.fromARGB(255, 18, 191, 136),
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
                  child: Image.asset('assets/logo1.png'),
                ),
                const SizedBox(height: 24.0),
                const Center(
                  child: Text(
                    'Registrar',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          controller: fullNameController,
                          decoration: const InputDecoration(
                            labelText: 'Nome completo',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nome completo é obrigatório';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirmar senha',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isConfirmPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirmação de senha é obrigatória';
                            } else if (value != passwordController.text) {
                              return 'As senhas não correspondem';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: isTermsAccepted,
                              onChanged: (bool? value) {
                                setState(() {
                                  isTermsAccepted = value ?? false;
                                });
                              },
                            ),
                            const Text('Concordo com os termos'),
                            TextButton(
                              onPressed: _showTermsDialog,
                              child: const Text(
                                'Ver termos',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16.0),
                            backgroundColor:
                                const Color.fromARGB(255, 18, 191, 136),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (!isTermsAccepted) {
                                _showErrorDialog(
                                    'Você deve aceitar os termos para se registrar.');
                                return;
                              }

                              try {
                                await createUser(
                                  fullNameController.text,
                                  emailController.text,
                                  passwordController.text,
                                );
                                print('Usuário cadastrado com sucesso!');
                                _showSuccessDialog();
                              } catch (e) {
                                _showErrorDialog(
                                    'Erro ao cadastrar usuário: $e');
                              }
                            }
                          },
                          child: const Text('Cadastrar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 18, 191, 136),
    );
  }
}
