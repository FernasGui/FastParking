import 'package:fastparking/loginPage.dart';
import 'package:flutter/material.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPage createState() => _PasswordResetPage();
}

class _PasswordResetPage extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Você pode adicionar mais controllers se precisar de mais campos

  @override
  void dispose() {
    // Lembre-se de limpar os controllers quando a tela for desmontada
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    // Aqui você implementará a lógica de registro
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');
    // Adicione sua lógica de registro aqui
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mudar a password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            
            SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Recuperar password'),
              keyboardType: TextInputType.emailAddress,
              // Adicione validações se necessário
            ),
          ],
        ),
      ),
    );
  }
}