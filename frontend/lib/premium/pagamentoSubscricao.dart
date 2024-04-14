import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PagamentoPremium extends StatefulWidget {
  @override
  _PagamentoPremiumState createState() => _PagamentoPremiumState();
}

class _PagamentoPremiumState extends State<PagamentoPremium> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _validadeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faz-te Premium'),
        backgroundColor: Color.fromRGBO(163, 53, 101, 1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.asset('imagens/cartaoCredito.png', width: 200, height: 150),
              ),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome no Cartão',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
              ),
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _numeroController,
              decoration: InputDecoration(
                labelText: 'Número do Cartão',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                hintText: "XXXX XXXX XXXX XXXX"
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _cvcController,
              decoration: InputDecoration(
                labelText: 'CVC',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                hintText: "XXX"
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [LengthLimitingTextInputFormatter(3)],
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _validadeController,
              decoration: InputDecoration(
                labelText: 'Validade',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                hintText: "mm/aa"
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  // Auto-inserts "/" after two digits
                  if (newValue.text.length == 2 && (oldValue.text.length < 2 || oldValue.text.length == 3)) {
                    if (newValue.text.contains('/')) {
                      return newValue;
                    } else {
                      return TextEditingValue(
                        text: '${newValue.text}/',
                        selection: TextSelection.collapsed(offset: 3),
                      );
                    }
                  } else if (newValue.text.length >= 3 && !newValue.text.contains('/')) {
                    // Corrects user deleting the "/"
                    return TextEditingValue(
                      text: '${newValue.text.substring(0, 2)}/${newValue.text.substring(2)}',
                      selection: TextSelection.collapsed(offset: newValue.text.length + 1),
                    );
                  }
                  return newValue;
                }),
                LengthLimitingTextInputFormatter(5),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _processarPagamento(),
              child: Text('Confirmar Pagamento'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromRGBO(163, 53, 101, 1),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processarPagamento() {
    print('Processando pagamento...');
    print('Nome: ${_nomeController.text}');
    print('Número do Cartão: ${_numeroController.text}');
    print('CVC: ${_cvcController.text}');
    
    Future.delayed(Duration(seconds: 1), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subscrição efetuada com sucesso!'), backgroundColor: Colors.green),
      );
      dispose();
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _numeroController.dispose();
    _cvcController.dispose();
    _validadeController.dispose();
    super.dispose();
  }
}
