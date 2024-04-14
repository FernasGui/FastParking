import 'package:fastparking/premium/pagamentoSubscricao.dart';
import 'package:flutter/material.dart';

class PremiumPage extends StatelessWidget {
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
            Image.asset('imagens/logo.png', width: 200, height: 150), // Certifique-se de ter essa imagem no diretório correto
            SizedBox(height: 20), // Espaço após o logotipo
            Text(
              'Vantagens do Plano Premium',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), 
            _buildFeatureTile('Acesso ao nosso serviço de chat', Icons.check_circle),
            _buildFeatureTile('Ofertas melhoradas', Icons.check_circle),
            _buildFeatureTile('Resolve os teus problemas mais rapidamente', Icons.check_circle),
            _buildFeatureTile('Contacta com os responsáveis do parque de forma mais prática', Icons.check_circle),
            SizedBox(height: 24),
            Text(
              'Apenas 2.00 €/mês',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(163, 53, 101, 1), // Por exemplo, cor do tema
              ),
              textAlign: TextAlign.center,
            ),

            // Espaço entre o valor do plano e o botão subscrever
            
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 32.0),
              child: 
              
      ElevatedButton(
  onPressed: () {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PagamentoPremium()),
    );
  },
  child: Text('Subscrever'),
  style: ElevatedButton.styleFrom(
    primary: Color.fromRGBO(163, 53, 101, 1), // Cor do botão
    onPrimary: Colors.white, // Cor do texto
    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0), // Padding
    textStyle: TextStyle(fontSize: 18), // Tamanho do texto
  ),
),

            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildFeatureTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Color.fromRGBO(163, 53, 101, 1)),
      title: Text(title),
    );
  }
}