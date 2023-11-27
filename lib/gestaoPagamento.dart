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
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestão de Saldo'),
      ),
      body: Column(
        children: [
          // ... Outros widgets ...

          // Seção dos botões de pagamento
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'CARREGUE A SUA CONTA',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Selecione o método de pagamento e carregue a sua conta EMEL com 5€ a 100€ sem qualquer comissão adicional. O valor que carregar fica disponível para utilizar no ePARK e GIRA.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MetodoCarregamentoButton(
                        imagePath: 'imagens/mbway.png', // Substitua pelo caminho correto da sua imagem
                       
                        onTap: () { 

                         },
                      ),
                      MetodoCarregamentoButton(
                        imagePath: 'imagens/paypal.png',
                       
                        onTap: () { 

                        },
                      ),
                      MetodoCarregamentoButton(
                        imagePath: 'imagens/Visa-Mastercard.jpg',
                        
                        onTap: () { print('Visa/MasterCard selecionado'); },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
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
        fit: BoxFit.fill, // Isso fará com que a imagem preencha todo o espaço do botão
      ),
    ),
  ),
);
  }
}
