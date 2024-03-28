import 'package:cloud_functions/cloud_functions.dart';
import 'package:fastparking/autenticacao/registerPage.dart';
import 'package:fastparking/ecraPrincipal/mapeamento.dart';
import 'package:fastparking/errorDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _loginButtonPressed() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      // Tenta fazer login com e-mail e senha usando o Firebase Authentication.
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navegue para a próxima tela após o login ser bem-sucedido.
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MapScreen()));

    } on FirebaseAuthException catch (e) {
      // Trata falhas de login com Firebase Auth Exception
      String errorMessage = 'Ocorreu um erro desconhecido.';
      if (e.code == 'user-not-found') {
        errorMessage = 'Nenhum usuário encontrado para esse e-mail.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Senha incorreta fornecida para esse usuário.';
      } // Adicione mais condições conforme necessário.

      ErrorDialog.showErrorDialog(
        context,
        'Erro de Login',
        errorMessage,
      );
    } catch (e) {
      // Trata outros erros que possam ocorrer
      ErrorDialog.showErrorDialog(
        context,
        'Erro de Login',
        'Não foi possível fazer login. Por favor, tente novamente mais tarde.',
      );
    }
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.1), // Espaço adicional no topo
              Image.asset('imagens/logo.png', width: 135, height: 135), // Adicione o logotipo aqui
              SizedBox(height: 60), // Espaço entre o logotipo e os campos de texto
              // Campo de texto para o e-mail
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  
                  labelText: 'E-mail',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(90.0)),

                ),
                
                
              ),
              SizedBox(height: 20),
              // Campo de texto para a senha
              TextFormField(
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
                child: Text('Não tem uma conta? Registe-se aqui.', style: TextStyle(color: Color(0xFF69285f)),),
                
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
