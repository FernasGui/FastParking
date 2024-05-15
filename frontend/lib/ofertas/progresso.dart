import 'package:cloud_functions/cloud_functions.dart';
import 'package:fastparking/ofertas/estacionamento.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OfertasPage extends StatefulWidget {
  @override
  _OfertasPageState createState() => _OfertasPageState();
}

class _OfertasPageState extends State<OfertasPage> {
  double progresso = 0.0; // Progresso inicial
  double scale = 1.0; // Escala inicial para o botão

  @override
  void initState() {
    super.initState();
    carregarProgresso(); // Carrega o progresso quando o widget é iniciado
  }

  Future<void> carregarProgresso() async {
    double novoProgresso =
        await calcularProgresso(FirebaseAuth.instance.currentUser?.uid ?? '');
    setState(() {
      progresso = novoProgresso;
    });
  }

  Future<void> _handleClaimOffer() async {
  try {
    final functions = FirebaseFunctions.instance;
    HttpsCallable callable = functions.httpsCallable('cashback');
    final results = await callable.call(<String, dynamic>{
      'uid': FirebaseAuth.instance.currentUser?.uid,
    });

    if (!mounted) return; // Verifica se o widget ainda está montado

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${results.data['message']}'), backgroundColor: Colors.green,)
    );

    // Resetar o progresso
    setState(() {
      progresso = 0.0;
    });
    
  } on FirebaseFunctionsException catch (e) {
    if (!mounted) return; // Verifica novamente antes de usar o context

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Falha ao aplicar cashback: ${e.message}'), backgroundColor: Colors.red)
    );
  } catch (e) {
    if (!mounted) return; // Verifica novamente antes de usar o context
    
    print(e); // Para debug
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro desconhecido ao tentar aplicar cashback.'), backgroundColor: Colors.red)
    );
  }
}

  @override
  Widget build(BuildContext context) {
    bool isComplete = progresso == 1.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ofertas'),
        backgroundColor: Color.fromRGBO(163, 53, 101, 1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('imagens/logo.png', width: 200),
            SizedBox(height: 30),
            Text(
              'Atinge o objetivo de estacionamentos em dias consecutivos para desbloquear as tuas ofertas.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            LinearProgressIndicator(
              value: progresso,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(163, 53, 101, 1)),
              minHeight: 8,
              borderRadius: BorderRadius.circular(30),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                '${(progresso * 5).round()}/5 estacionamentos consecutivos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            SizedBox(height: 200),
            GestureDetector(
              onTapDown: (_) => setState(() =>
                  scale = 0.6), // Reduz a escala quando o botão é pressionado
              onTapUp: (_) => setState(
                  () => scale = 10.0), // Retorna à escala normal quando solto
              onTapCancel: () => setState(() => scale =
                  1.0), // Retorna à escala normal se o toque é cancelado
              child: AnimatedScale(
                scale: scale,
                duration: const Duration(milliseconds: 100),
                child: ElevatedButton(
                  onPressed: isComplete ? _handleClaimOffer : null,
                  style: ElevatedButton.styleFrom(
                    primary: isComplete
                        ? Color.fromRGBO(52, 205, 35, 1)
                        : Colors.grey,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text("Reivindicar cashback",
                      style: TextStyle(fontSize: 22)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
