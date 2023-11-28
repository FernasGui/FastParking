import 'package:fastparking/mapeamento.dart';
import 'package:fastparking/registerPage.dart';
import 'package:flutter/material.dart';
import 'package:fastparking/customButton.dart';


class GestaoPagamento extends StatefulWidget {
  const GestaoPagamento({Key? key}) : super(key: key);

  @override
  _GestaoPagamentoState createState() => _GestaoPagamentoState();
}

class _GestaoPagamentoState extends State<GestaoPagamento> {
  @override
  Widget build(BuildContext context) {
    // Espaçamento no topo da tela, ajustável conforme necessário
    double topPadding = MediaQuery.of(context).size.height * 0.02;

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestão de Saldo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: topPadding),
            // Logotipo do topo (ajustar o caminho para o logotipo conforme necessário)
            Image.asset('imagens/logo.png', height: 160),
            SizedBox(height: topPadding),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'CARREGUE A SUA CONTA',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Selecione o método de pagamento e carregue a sua conta Fastparking. Carregamento com o valor mínimo de 5€.',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                MetodoCarregamentoButton(
                  imagePath: 'imagens/mbway.png',
                  onTap: () {
                    _showBottomSheet(context);
                  },
                ),
                MetodoCarregamentoButton(
                  imagePath: 'imagens/Paypal.png',
                  onTap: () {
                    // Lógica para o botão PayPal
                  },
                ),
                
                MetodoCarregamentoButton(
                  imagePath: 'imagens/Visa-Mastercard.png',
                  onTap: () {
                    // Lógica para o botão Visa/MasterCard
                  },
                ),
              ],
            ),
            SizedBox(height: 20), // Espaço adicional no final da tela
          ],
        ),
      ),
    );
  }

      void _showBottomSheet(BuildContext context) {
  TextEditingController phoneNumberController = TextEditingController();

  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Wrap(
          children: <Widget>[
            Text(
              'O método de pagamento selecionado enviará uma confirmação de pagamento para você. Confirme se o número do seu telemóvel está correto.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Text(
                  '+351',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      hintText: 'Digite seu número de telemóvel',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Align(
            alignment: Alignment.centerRight,
            child: 
            ElevatedButton(
              onPressed: () {
                print('Número de telemóvel: +351${phoneNumberController.text}');
                Navigator.pop(context);
              },
              child: Text('Confirme'),
              style: ElevatedButton.styleFrom(
                primary:  Color.fromRGBO(163, 53, 101, 1),
                onPrimary: Colors.white,
              ),
            )
            )
          ],
        ),
      );
    },
  );
}


}

class MetodoCarregamentoButton extends StatelessWidget {
  final String imagePath; // Adicionado para permitir a especificação do caminho da imagem
  
  final VoidCallback onTap;

  MetodoCarregamentoButton({
    required this.imagePath, // Alterado para aceitar o caminho da imagem
    
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
  onPressed: onTap,
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(18)),
    ),
    primary: Colors.white, // Cor de fundo do botão
    onPrimary: Color.fromARGB(255, 163, 53, 101), // Cor de fundo do botão ao pressionar
    padding: EdgeInsets.zero, // Remover o padding interno
    // Configurar o tamanho mínimo para zero para que o botão seja do tamanho da imagem
    minimumSize: Size.zero, 
    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Remove margens adicionais
  ),
  child: Ink(
    decoration: BoxDecoration(
      // Aplicar o mesmo borderRadius que o botão para a decoração
      borderRadius: BorderRadius.all(Radius.circular(18)),
    ),
    child: Container(
      // Configurar as dimensões do Container para corresponder ao tamanho desejado do botão
      width: 80, // Por exemplo, 80 unidades lógicas
      height: 80, // Por exemplo, 80 unidades lógicas
      alignment: Alignment.center, // Centralizar a imagem dentro do Container
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover, // Isso fará com que a imagem preencha todo o espaço do botão
      ),
    ),
  ),
);
  }

}