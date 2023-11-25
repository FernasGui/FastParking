import 'package:fastparking/loginPage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
//import 'loginPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage())));
  }

  @override
  Widget build(BuildContext context) {
     Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
            child: Image.asset('imagens/begin.png', // Certifique-se de que a imagem está na pasta correta.
            fit: BoxFit.fill, // Isso fará com que a imagem cubra toda a tela.
          ),
        ),
    );
  }
}