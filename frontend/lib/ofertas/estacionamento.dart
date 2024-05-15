import 'package:cloud_firestore/cloud_firestore.dart';

Future<double> calcularProgresso(String uid) async {
  DateTime now = DateTime.now();
  DateTime inicio = DateTime(now.year, now.month, now.day).subtract(Duration(days: 4));
  DateTime fim = DateTime(now.year, now.month, now.day, 23, 59, 59); // Inclui todo o dia atual

  var querySnapshot = await FirebaseFirestore.instance
    .collection('EstacionamentoExpirado')
    .where('UID', isEqualTo: uid)
    .where('HoraEntrada', isGreaterThanOrEqualTo: inicio)
    .where('HoraEntrada', isLessThanOrEqualTo: fim)
    .orderBy('HoraEntrada', descending: true) // Ordenando do mais recente para o mais antigo
    .get();

  List<DateTime> diasUnicos = [];
  for (var doc in querySnapshot.docs) {
    DateTime entrada = (doc.data() as Map<String, dynamic>)['HoraEntrada'].toDate();
    DateTime dataLocal = DateTime(entrada.year, entrada.month, entrada.day);
    if (!diasUnicos.contains(dataLocal)) {
      diasUnicos.add(dataLocal);
    }
  }

  // Verifica se os dias são consecutivos
  int diasConsecutivos = 1; // Começa com 1 se houver pelo menos um dia
  if (diasUnicos.isNotEmpty) {
    for (int i = 1; i < diasUnicos.length; i++) {
      if (diasUnicos[i].difference(diasUnicos[i - 1]).inDays == -1) {
        diasConsecutivos++;
      } else {
        break; // Interrompe a contagem assim que encontrar uma não consecutividade
      }
    }
  }

  return diasConsecutivos / 5.0;
}
