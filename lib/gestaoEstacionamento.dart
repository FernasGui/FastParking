import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EstacionamentoManager {
  final BuildContext context;

  EstacionamentoManager(this.context);

  Future<void> mostrarDetalhesEstacionamento() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final estacionamentoSnapshot = await FirebaseFirestore.instance
            .collection('Estacionamentos')
            .where('userId', isEqualTo: user.uid)
            .where('estado', isEqualTo: 'ativo')
            .limit(1)
            .get();

        if (estacionamentoSnapshot.docs.isNotEmpty) {
          final estacionamentoData = estacionamentoSnapshot.docs.first.data();
          final zona = estacionamentoData['zona'];
          final lugar = estacionamentoData['lugar'];
          exibirJanelaInformativa('Esqueceste-te do teu lugar? Andas com a cabeça no ar!', 'Zona: $zona Lugar: $lugar');
        } else {
          exibirJanelaInformativa('Nenhum estacionamento ativo', 'Você não possui um estacionamento ativo no momento.');
        }
      } catch (e) {
        exibirJanelaInformativa('Erro', 'Não foi possível buscar as informações de estacionamento: $e');
      }
    } else {
      exibirJanelaInformativa('Usuário não logado', 'Por favor, faça login para ver os detalhes do estacionamento.');
    }
  }

  void exibirJanelaInformativa(String titulo, String conteudo) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white, // Define a cor de fundo do AlertDialog para branco
        title: Text(
          titulo,
          textAlign: TextAlign.center,
            style: TextStyle(
            color: Colors.black, // Cor do texto do título
            fontSize: 19, // Tamanho da fonte do título
          ),// Define a cor do texto do título para preto
        ),
        content: Text(
          conteudo,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black, // Cor do texto do título
            fontSize: 18, // Tamanho da fonte do título
          ),// Define a c // Define a cor do texto do conteúdo para preto
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Ok',
              style: TextStyle(color: Colors.black), // Define a cor do texto do botão para preto
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}
