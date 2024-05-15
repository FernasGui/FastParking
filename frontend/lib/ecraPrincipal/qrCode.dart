import 'dart:convert';

import 'package:fastparking/dialogoUtil.dart';
import 'package:fastparking/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_functions/cloud_functions.dart';

class QRCodeManager{

void showMatriculasDialog(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // Se o usuário não estiver logado, exibe uma mensagem ou lida de outra forma
    DialogoUtil.exibirJanelaInformativa(
      context,
      'Usuário não logado',
      'Por favor, faça o login para continuar.',
    );
    return;
  }

  // Exibe o diálogo com as matrículas
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Com que máquina vieste hoje?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        content: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('Matriculas').doc(user.uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null || !(snapshot.data as DocumentSnapshot).exists) {
              return const Text('Ainda sem matrículas registadas');
            }
            
            // Converte os dados do documento em uma lista de veículos
            final veiculos = List<Map<String, dynamic>>.from(snapshot.data!['veiculos'] ?? []);
            
            // Verifica se existem veículos
            if (veiculos.isEmpty) {
              return const Text('Nenhuma matrícula encontrada.');
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: veiculos.map((veiculo) {
                return ListTile(
                  title: Text(veiculo['matricula'] ?? 'Sem matrícula'),
                  subtitle: Text(veiculo['descrição'] ?? 'Sem descrição'),
                  onTap: () {
                    // Aqui você pode chamar a função para gerar o QR Code
                    generateQRCode(context, veiculo['matricula']);
                    Navigator.of(context).pop(); // Fecha o diálogo
                    
                  },
                );
              }).toList(),
            );
          },
        ),
      );
    },
  );
}

// Chama a Cloud Function para gerar o QR Code

void showQRCodeDialog(String qrData) {
  if (navigatorKey.currentState?.mounted ?? false) {
    showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Aplica um arredondamento nos cantos do diálogo
          ),
          child: Container(
            padding: EdgeInsets.all(15), // Espaço interno para todo o conteúdo do Container
            decoration: BoxDecoration(
              color: Colors.white, // Fundo branco para o diálogo
              borderRadius: BorderRadius.circular(30), // Borda arredondada
              border: Border.all(
                color: const Color.fromRGBO(163, 53, 101, 1), // Cor personalizada para a borda
                width: 6, // Largura da borda
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 220.0,
                ),
                
               
              ],
            ),
          ),
        );
      },
    );
  }
}



/*
void generateQRCode(BuildContext context, String matricula) async {
 
  try {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('checkSaldoAndGenerateQR');
    final result = await callable.call({'matricula': matricula});
    print('Resultado da Cloud Function: ${result.data}');

   if (result.data is Map) {
  var qrDataMap = result.data['qrData']; // Acesso direto à propriedade qrData
  if (qrDataMap is Map) {
    var qrDataString = jsonEncode(qrDataMap); // Encode somente a parte qrData
    showQRCodeDialog(qrDataString);
  }
} else {
  print('O resultado recebido não está no formato esperado.');
}
  } on FirebaseFunctionsException catch (e) {
    if (navigatorKey.currentState?.overlay?.context != null) { // Use overlay.context para diálogos
      DialogoUtil.exibirJanelaInformativa(
        navigatorKey.currentState!.overlay!.context,
        'Saldo Insuficiente',
        '${e.message}',
      );
    }
  }
}
*/

void generateQRCode(BuildContext context, String matricula) async {
   //const parqueID = "P1";
  const parqueID = "P2";
  //const parqueID = "P3";
  try {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('checkSaldoAndGenerateQR');
    final result = await callable.call({'matricula': matricula, 'parqueID': parqueID});
    

    if (result.data is Map) {
      var qrDataMap = result.data['qrData'];
      if (qrDataMap is Map) {
      var qrDataString = jsonEncode(qrDataMap); // Encode somente a parte qrData
        showQRCodeDialog(qrDataString);
        _registarEntradaEstacionamento(context ,qrDataMap);
      }
    } else {
      print('O resultado recebido não está no formato esperado.');
    }
  } on FirebaseFunctionsException catch (e) {
    // Tratar erros, como saldo insuficiente ou outros erros
    DialogoUtil.exibirJanelaInformativa(
      navigatorKey.currentState!.overlay!.context,
      'Erro ao gerar QR Code',
      '${e.message}',
    );
  }
}

 Future<void> _registarEntradaEstacionamento(BuildContext context, Map qrDataMap) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('registarEntradaEstacionamento');
    
     final result = await callable.call({'uid': qrDataMap['uid'], 'matricula': qrDataMap['matricula'], 'parqueID': qrDataMap['parqueID'],
      });
       print('Resultado da Cloud Function: ${result.data}');
    
    // Exibir diálogo de sucesso ou atualizar a interface com a resposta
    DialogoUtil.exibirJanelaInformativa(
      navigatorKey.currentState!.overlay!.context,
      'Sucesso',
      'Entrada bem-sucedida!',
    );
  } on FirebaseFunctionsException catch (e) {
    
    DialogoUtil.exibirJanelaInformativa(
      navigatorKey.currentState!.overlay!.context,
      'Atenção',
      '${e.message}',
    );
  }
} 
}
