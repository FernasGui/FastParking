import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fastparking/dialogoUtil.dart';
import 'package:fastparking/informacoes/tarifasParques.dart';
import 'package:fastparking/informacoes/tutorial.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informações'),
        backgroundColor: Color.fromRGBO(163, 53, 101, 1),
        foregroundColor: Colors.white, // Cor da AppBar.
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Image.asset('imagens/logo.png', width: 225, height: 150),
            SizedBox(height: 70), // Espaço entre o logo e o primeiro botão.
            SizedBox(
              width: 270.0, 
              height: 55.0,
              child: ElevatedButton(
                onPressed: () {
                   Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TutorialPage(),
              ));
                },
                child: Text(
                  'Tutorial da app',
                  style: TextStyle(color: Colors.white), // Cor do texto.
                  textScaleFactor: 1.5
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(163, 53, 101, 1), // Cor do botão.
                ),
              ),
              ),
            
            SizedBox(height: 40), // Espaço entre os botões.
            SizedBox(
               width: 270.0, 
              height: 55.0,
              child: ElevatedButton(
                onPressed: () {
                     Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TarifasParquesPage(),
              ));
                },
                child: Text(
                  'Tarifas',
                  style: TextStyle(color: Colors.white), // Cor do texto.
                  textScaleFactor: 1.5
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(163, 53, 101, 1), // Cor do botão.
                ),
              ),
              ),
            SizedBox(height: 40), // Espaço entre os botões.
            SizedBox(
              width: 270.0, 
              height: 55.0,
              child: ElevatedButton(
                onPressed: () {
                    exitParque(context);
                  
                },
                child: Text(
                  'Simular Saída',
                  style: TextStyle(color: Colors.white),
                  textScaleFactor: 1.5 , // Cor do texto.
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(163, 53, 101, 1), // Cor do botão.
                ),
              ),
              ),
          ],
        ),
      ),
    );
  }

  void exitParque(BuildContext context){
    String? userId = FirebaseAuth.instance.currentUser?.uid;
                   if (userId != null) {
                      FirebaseFirestore.instance
                        .collection('EstacionamentoAtivo')
                        .where('UID', isEqualTo: userId)
                        .limit(1) // Limita a busca ao primeiro resultado encontrado
                        .get()
                        .then((querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) { 
                           simularSaida();
                           ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Saída bem-sucedida!'), backgroundColor: Colors.green),
                            );
                          } else {
                           DialogoUtil.exibirJanelaInformativa(
                              context,
                              'Atenção',
                              'Não tens nenhum estacionamento ativo',
                            );
                          }
                        })
                        .catchError((error) {
                          // Trate o erro conforme necessário
                        });
                    } else {
                        DialogoUtil.exibirJanelaInformativa(
                              context,
                              'Erro',
                              'Faz login para utilizares a aplicação',
                            );
                  }
  }

    Future<void> simularSaida() async {
    User? user = FirebaseAuth.instance.currentUser;
    
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('registarSaidaEstacionamento');
      final result = await callable.call({'uid': user?.uid});
     
      print('Resposta da função: ${result.data}');
    } on FirebaseFunctionsException catch (e) {
      print('Erro ao chamar a função: ${e.code} - ${e.message}');
    }
  }
}
