import 'package:flutter/material.dart';

class RegisterPages extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPages> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  // Você pode adicionar mais controllers se precisar de mais campos

  @override
  void dispose() {
    // Lembre-se de limpar os controllers quando a tela for desmontada
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _register() {
    // Aqui você implementará a lógica de registro
    print('Name: ${_nameController.text}');
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');
    print('Phone: ${_phoneController.text}');
    // Adicione sua lógica de registro aqui
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome próprio'),
              keyboardType: TextInputType.name,
              // Adicione validações se necessário
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
              // Adicione validações se necessário
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true, // Esconde a senha
              // Adicione validações se necessário
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Telemóvel'),
              keyboardType: TextInputType.phone,
              // Adicione validações se necessário
            ),
            SizedBox(height: 24),
            ElevatedButton(
              child: Text('Registrar'),
              onPressed: _register, // Chama a função de registro
            ),
          ],
        ),
      ),
    );
  }
}