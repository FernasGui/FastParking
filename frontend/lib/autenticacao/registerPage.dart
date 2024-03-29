import 'package:fastparking/autenticacao/loginPage.dart';
import 'package:fastparking/errorDialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';



class RegisterPages extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPages> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
  if (_formKey.currentState!.validate()) {
    String nome = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;

   final FirebaseFunctions functions = FirebaseFunctions.instance;

      try {
        // Chama a função 'registerUser' do Firebase Cloud Functions
        final HttpsCallableResult result = await functions
            .httpsCallable('registerUser')
            .call({'nome': nome, 'email': email, 'password': password});

        if (result.data['status'] == 'success') {
          // Se o usuário foi registrado com sucesso, redireciona para a página de login
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          ErrorDialog.showErrorDialog(
            context,
            'Erro de Registo',
            'Falha ao registar. Por favor, tente novamente mais tarde.'
          );   
        }
      } on FirebaseFunctionsException catch (e) {
  // Garante que a mensagem de erro não é nula antes de usá-la.
  final errorMessage = e.message ?? 'Ocorreu um erro desconhecido.';
  ErrorDialog.showErrorDialog(
     context,
     'Erro de Registo',
     errorMessage,
  );
}

    }
  }


  @override
  Widget build(BuildContext context) {
  return Scaffold(
    
  
    body: SingleChildScrollView( // Isso permite rolar a tela quando o teclado aparece
      child: Padding(
        padding: const EdgeInsets.all(20.0),
       child: Form( // O widget Form deve ser colocado aqui
          key: _formKey, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.1), // Espaço adicional no topo
              Image.asset('imagens/logo.png', width: 150, height: 150), // Adicione o logotipo aqui
              SizedBox(height: 30), // Espaço entre o logotipo e os campos de texto
              // Campo de texto para o e-mail
             TextFormField(
  controller: _nameController,
  decoration: InputDecoration(
    labelText: 'Nome próprio',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(90.0)),
  ),
  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira o seu nome.';
    }
    return null;
  },
),
SizedBox(height: 20),
TextFormField(
  controller: _emailController,
  decoration: InputDecoration(
    labelText: 'E-mail',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(90.0)),
  ),
  validator: (value) {
    if (value == null ) {
      return 'Por favor, insira um e-mail válido.';
    }
    return null;
  },
),
SizedBox(height: 20),
TextFormField(
  controller: _passwordController,
  decoration: InputDecoration(
    labelText: 'Password',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(90.0)),
  ),
  obscureText: true,
  validator: (value) {
    if (value == null ) {
      return 'A senha não cumpre os requisitos. Deve ter pelo menos 6 caracteres, incluindo números e letras.';
    }
    return null;
  },
),
                

              SizedBox(height: 40),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF69285f), // Cor de fundo do botão
                    onPrimary: Colors.white, // Cor do texto do botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    minimumSize: Size.fromHeight(50), // Altura do botão
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _register();
                    }
                  },
                  child: Text('Registar-me'),
                ),
              TextButton(
                child: Text('Já tem conta? Faça login!', style: TextStyle(color: Color(0xFF69285f)),),
                
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                },
                   ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
