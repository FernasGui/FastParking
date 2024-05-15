import 'package:fastparking/premium/subscricaoPage.dart';
import 'package:flutter/material.dart';

class notPremium extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

        return Scaffold(
      appBar: AppBar(
        title: Text('Faz-te Premium'),
        backgroundColor: Color.fromRGBO(163, 53, 101, 1),
        foregroundColor: Colors.white, // Cor do texto do AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20), // Espaço antes do logotipo
            Image.asset('imagens/notPremium.jpg', width: 300, height: 200), // Certifique-se de ter essa imagem no diretório correto
            SizedBox(height: 40), // Espaço após o logotipo
            Text(
              'Calma lá... Tu ainda não és premium.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), 
             Text(
              'Pssst... Sim, tu! \n  Se queres teres acesso a este recurso tens de te fazer premium.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
             SizedBox(height: 100), 
                ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PremiumPage()),
                  );
                },
                child: Text('Fazer-me premium'),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(163, 53, 101, 1), // Cor do botão
                  onPrimary: Colors.white, // Cor do texto
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0), // Padding
                  textStyle: TextStyle(fontSize: 18), // Tamanho do texto
                ),
              ),
            
          ],
        ),
      ),
    );
  }
}