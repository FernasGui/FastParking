import 'package:fastparking/autenticacao/loginPage.dart';
import 'package:fastparking/autenticacao/servicoRegisto.dart';
import 'package:flutter/material.dart';

class RegisterPages extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPages> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  AutenticacaoServico _autentServ = AutenticacaoServico();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    Pattern pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern as String);
    return regex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6 && password.contains(RegExp(r'[0-9]')) && password.contains(RegExp(r'[A-Za-z]'));
  }

  void _register() async {
  if (_formKey.currentState!.validate()) {
    String nome = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      bool registrationSuccessful = await _autentServ.autenticacaoUser(nome: nome, email: email, password: password);

      if (registrationSuccessful) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        _showErrorDialog('Falha ao registrar. Por favor, tente novamente mais tarde.');
      }
    } catch (e) {
      // Log de erro para depuração
      print('Erro no registro: $e');
      _showErrorDialog('Ocorreu um erro inesperado. Por favor, tente novamente mais tarde.');
    }
  } else {
    print('Falha na validação. Por favor, corrija os erros antes de continuar.');
  }
}

void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Erro de Registro'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
      ],
    ),
  );
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
    if (value == null || !_isValidEmail(value)) {
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
    if (value == null || !_isValidPassword(value)) {
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
