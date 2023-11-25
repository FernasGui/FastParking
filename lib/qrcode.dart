import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class QrCodePage extends StatelessWidget {
  const QrCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          const GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(38.736946, -9.142685), // Substitua com a sua localização inicial
              zoom: 14.0,
            ),
            // Adicione mais configurações de acordo com suas necessidades
          ),
          Container(
            width: 240, //  aumentar tamanho caso necessite
            height: 240, //  aumentar tamanho caso necessite
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset('imagens/Qrcode_grande.png'), // Substitua pelo caminho do seu QR Code
            ),
          ),
        ],
      ),
      // Incluindo a BottomNavigationBar no Scaffold
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR Code',
          ),
          // Adicione mais BottomNavigationBarItems se precisar
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context); // Retorna para a tela anterior no stack de navegação
          }
          // Adicione mais ações para outros itens se necessário
        },
      ),
    );
  }
}
