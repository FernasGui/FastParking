import 'package:flutter/material.dart';
import 'package:fastparking/informacoes/fotoCarousel.dart';

class TutorialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const String logoPath = 'imagens/logo.png'; // Substitua com o caminho correto do seu logo

    return Scaffold(
      appBar: AppBar(
        title: Text('Tutorial'),
        backgroundColor: Color.fromRGBO(163, 53, 101, 1),
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: Image.asset(logoPath, height: 100),
          ),
          Expanded(
            // O carrossel é envolvido por um Expanded para preencher o espaço restante
            child: SwipablePhotoCarousel(
              imagePaths: [
                'imagens/marcadoresTutorial.jpg',
                'imagens/QRtutorial.jpg',
                'imagens/premiumTutorial.jpg',
                'imagens/menuTutorial.jpg',
                'imagens/lugarTutorial.jpg',
              ],
            ),
          ),
          Padding(
  padding: const EdgeInsets.only(bottom: 20.0),
  child: Center(
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Desliza para mais dicas ",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Certifique-se de definir uma cor para TextSpan
            ),
          ),
          WidgetSpan(
            child: Icon(Icons.arrow_forward, size: 18.0), // Emoji de seta para a direita como ícone
          ),
        ],
      ),
    ),
  ),
),
          SizedBox(height: 20),
          // Aqui você pode adicionar outro texto ou widget conforme sua necessidade
        ],
      ),
    );
  }
}
