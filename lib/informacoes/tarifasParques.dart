import 'package:flutter/material.dart';

class TarifasParquesPage extends StatelessWidget {
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
            SizedBox(height: 10),
             SizedBox( // Espaço entre o logo e o primeiro botão.
             child: Text(
                'Relembramos-te que os valores das tarifas são definidos pelos parques e a utilização da FastParking em nada influencia o valor das mesmas.',
                textAlign: TextAlign.center,
              ),
              ),
            SizedBox(height: 50),
            SizedBox(
              width: 270.0, 
              height: 55.0,
              child: ElevatedButton(
                onPressed: () {
                  // Ação do botão Tutorial da app.
                },
                child: Text(
                  'Parque Cidade Universitária',
                  style: TextStyle(color: Colors.white), // Cor do texto.
                  textScaleFactor: 1.25
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
               
                },
                child: Text(
                  'Parque Campo Grande',
                  style: TextStyle(color: Colors.white), // Cor do texto.
                  textScaleFactor: 1.25
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
                  'Parque Saba Estádio Univ.',
                  style: TextStyle(color: Colors.white),
                  textScaleFactor: 1.25 , // Cor do texto.
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
