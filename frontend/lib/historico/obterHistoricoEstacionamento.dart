import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

// Esta função busca os últimos 5 registros de estacionamento expirado do usuário e chama a função de atualização de UI
 String  formatTimestampToHourMinute(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  DateTime dateTimeLocal = dateTime.add(Duration(hours: 1));
  String formattedTime = DateFormat('HH:mm').format(dateTimeLocal);
  return formattedTime;
}

String formatTimestampToDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
  return formattedDate;
}

void obterHistoricoEstacionamento(Function(List<Map<String, dynamic>>) callbackAtualizacaoUI) {
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  FirebaseFirestore.instance
    .collection('EstacionamentoExpirado')
    .where('UID', isEqualTo: userId)
    .orderBy('HoraEntrada', descending: true)
    .limit(5)
    .get()
    .then((querySnapshot) {
      List<Map<String, dynamic>> listaHistorico = querySnapshot.docs.map((doc) {
        
        return {
          'data': formatTimestampToDate(doc.data()['HoraEntrada'] as Timestamp),
          'nomeParque': doc.data()['NomeParque'] ?? '',
          'entrada': formatTimestampToHourMinute(doc.data()['HoraEntrada']),
          'saida':formatTimestampToHourMinute(doc.data()['HoraSaida']),
          'preco': doc.data()['Preco']?.toStringAsFixed(2) ?? '0.00',
        };
      }).toList();

      if (listaHistorico.isNotEmpty) {
        print('Lista de histórico não está vazia, atualizando UI');
        callbackAtualizacaoUI(listaHistorico);
      } else {
        print('Lista de histórico está vazia');
      }
    })
    .catchError((error) {
      print("Ocorreu um erro ao buscar o histórico: $error");
    });

 
}


