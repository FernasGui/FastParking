import 'package:flutter/material.dart';
import 'package:fastparking/mapeamento.dart';
import 'package:fastparking/registerPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _loginButtonPressed() {
    String email = emailController.text;
    String password = passwordController.text;
    print('Email: $email, Password: $password');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView( // Envolve o corpo em um SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.0), // Espaço adicional no topo
              Image.asset('imagens/logo.png', width: 275, height: 250), // Adicione o logotipo aqui
              SizedBox(height: 30), // Espaço entre o logotipo e os campos de texto
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
                  primary: Color(0xFF69285f), // Cor de fundo do botão
                  onPrimary: Colors.white, // Cor do texto do botão
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minimumSize: Size.fromHeight(50), // altura do botão
                ),
                onPressed: _loginButtonPressed,
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  // Implementar recuperação de senha
                },
                child: Text(
                  'Esqueceu a senha?',
                  style: TextStyle(color: Color(0xFF69285f)),
                ),
              ),
              TextButton(
                child: Text('Não tem uma conta? Registre-se aqui.', style: TextStyle(color: Color(0xFF69285f)),),
                
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPages()));
                },
              ),
              SizedBox(height: 20), // Espaço adicional no final
            ],
          ),
        ),
      ),
    );
  }
}
