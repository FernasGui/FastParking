import 'package:flutter/material.dart';


import 'registerPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _loginButtonPressed() {
    String email = emailController.text;
    String password = passwordController.text;
    // Aqui você pode implementar a lógica de autenticação
    print('Email: $email, Password: $password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Campo de texto para o e-mail
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(90.0)),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            // Campo de texto para a senha
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(90.0)),
              ),
              obscureText: true,
            ),
            SizedBox(height: 40),
            // Botão de Login
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                minimumSize: Size.fromHeight(50), // altura do botão
              ),
              onPressed: _loginButtonPressed,
              child: Text('Login'),
            ),
           // TextButton(
           //   onPressed: () {
           //     // Implement
          TextButton(
            onPressed: () {
          // Aqui você adicionará a lógica para lidar com a recuperação de senha
          // Por exemplo, navegar para uma nova tela onde o usuário pode solicitar uma redefinição de senha
          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => PasswordResetPage()));
          },
         child: Text(
        'Esqueceu a senha?',
         style: TextStyle(color: Colors.blue),
        ),
        ),

        // Aqui adiciona a página de registo para quem não tem conta criar
        TextButton(
              child: Text('Não tem uma conta? Registre-se aqui.'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPages()));
               // Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPage()));
              },
            ),
        // Você pode querer adicionar um espaçamento ou um divisor aqui, se necessário
        SizedBox(height: 20)])));
       
      }    
    }
  