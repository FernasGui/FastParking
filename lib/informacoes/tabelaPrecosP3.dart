 import 'package:flutter/material.dart';
import 'package:fastparking/informacoes/tabela.dart'; // Garanta que este arquivo contém o widget 'PriceTable'.

class PricePage3 extends StatelessWidget {
  final String logoPath = 'imagens/logo.png'; // Substitua com o caminho correto do seu logo

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> data = [
      {'tempo': '1 hora', 'preco': 'Grátis'},
      {'tempo': '2 horas', 'preco': '2.5€'},
      {'tempo': '3 horas', 'preco': '4.0€'},
      {'tempo': '4 horas', 'preco': '5.50€'},
      {'tempo': '5 horas', 'preco': '6.50€'},
      {'tempo': 'Bilhete perdido', 'preco': '8.50€'},
      // Adicione mais dados conforme necessário
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Parque Saba Estádio Univ.'),
        backgroundColor: Color.fromRGBO(163, 53, 101, 1),
        foregroundColor: Colors.white, // Cor da AppBar.
        centerTitle: true, // Certifique-se de que o título esteja centralizado
      ),
      body: Column(
        children: [
           SizedBox(height: 20), // Espaço no topo
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Image.asset(logoPath, width: 225, height: 150), // Logo no topo
          ),
          Expanded(
            child: Center(
              child: PriceTable(data: data), // Tabela centralizada
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1), // Espaço no fundo
        ],
      ),
    );
  }
}
