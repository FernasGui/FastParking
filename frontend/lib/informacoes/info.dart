import 'package:fastparking/informacoes/tarifasParques.dart';
import 'package:fastparking/informacoes/tutorial.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informações'),
        backgroundColor: Color.fromRGBO(163, 53, 101, 1),
        foregroundColor: Colors.white, // Cor da AppBar.
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Image.asset('imagens/logo.png', width: 225, height: 150),
            SizedBox(height: 70), // Espaço entre o logo e o primeiro botão.
            SizedBox(
              width: 270.0, 
              height: 55.0,
              child: ElevatedButton(
                onPressed: () {
                   Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TutorialPage(),
              ));
                },
                child: Text(
                  'Tutorial da app',
                  style: TextStyle(color: Colors.white), // Cor do texto.
                  textScaleFactor: 1.5
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(163, 53, 101, 1), // Cor do botão.
                ),
              ),
              ),
            
            SizedBox(height: 40), // Espaço entre os botões.
            SizedBox(
               width: 270.0, 
              height: 55.0,
              child: ElevatedButton(
                onPressed: () {
                     Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TarifasParquesPage(),
              ));
                },
                child: Text(
                  'Tarifas',
                  style: TextStyle(color: Colors.white), // Cor do texto.
                  textScaleFactor: 1.5
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(163, 53, 101, 1), // Cor do botão.
                ),
              ),
              ),
            SizedBox(height: 40), // Espaço entre os botões.
            SizedBox(
              width: 270.0, 
              height: 55.0,
              child: ElevatedButton(
                onPressed: () {
                  // Ação do botão Tutorial da app.
                },
                child: Text(
                  'Info',
                  style: TextStyle(color: Colors.white),
                  textScaleFactor: 1.5 , // Cor do texto.
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(163, 53, 101, 1), // Cor do botão.
                ),
              ),
              ),
          ],
        ),
      ),
    );
  }
}
