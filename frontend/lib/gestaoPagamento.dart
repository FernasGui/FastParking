import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GestaoPagamento extends StatefulWidget {
  const GestaoPagamento({Key? key}) : super(key: key);

  @override
  _GestaoPagamentoState createState() => _GestaoPagamentoState();
}

class _GestaoPagamentoState extends State<GestaoPagamento> {
  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).size.height * 0.01;

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestão de Saldo'),
        backgroundColor:  Color.fromRGBO(163, 53, 101, 1), 
        foregroundColor: Color.fromRGBO(255, 255, 255, 1),
       
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: topPadding),
            Image.asset('imagens/logo.png', width: 200, height: 150),
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
                  onTap: () => _showBottomSheet(context),
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController chargeAmountController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext bc) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use min to make the column wrap content
              children: <Widget>[
                Text(
                  'Insira o valor a carregar e confirme se o número do seu telemóvel está correto. Será enviada uma confirmação para a sua aplicação Mb Way.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: chargeAmountController,
                  decoration: InputDecoration(
                    labelText: 'Valor a carregar',
                    suffixIcon: Icon(Icons.euro_symbol),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || int.tryParse(value) == null || int.parse(value) < 5) {
                      return 'Valor mínimo: 5€';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: '+351',
                    hintText: 'Digite seu número de telemóvel',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || !RegExp(r'^9\d{8}$').hasMatch(value)) {
                      return 'Digite um número de 9 dígitos que comece com 9';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Se o valor e o número do telemóvel forem válidos
                      final double carregamento = double.tryParse(chargeAmountController.text) ?? 0;
                      final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

                      // Verifica se o uid não está vazio
                      if (uid.isNotEmpty) {
                        // Incrementa o saldo do usuário no Firestore
                        await FirebaseFirestore.instance.collection('Users').doc(uid).update({
                          'saldo': FieldValue.increment(carregamento),
                        });

                         FirebaseFirestore.instance.collection('Histórico').add({
                          'Data': FieldValue.serverTimestamp(),
                          'Transação': 'Carregamento' , 
                          'Valor': carregamento,

                        });

                        // Fecha a BottomSheet após a atualização bem-sucedida
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Carregamento efetuado com sucesso!'),
                           backgroundColor: Colors.green,),

                        );
                      } else {
                        // Mostra uma mensagem de erro se o uid estiver vazio
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao carregar saldo. Tente novamente.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Confirmar'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF69285F),
                    onPrimary: Colors.white,
                        ),
                ),
              ],
            ),
              ],
        ),
      ),),);
    },
  );
}
}


class MetodoCarregamentoButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  MetodoCarregamentoButton({
    required this.imagePath,
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
        primary: Colors.white,
        onPrimary: Color.fromARGB(255, 163, 53, 101),
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        child: Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}