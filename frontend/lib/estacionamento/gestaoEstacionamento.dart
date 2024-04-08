import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastparking/dialogoUtil.dart';
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
          DialogoUtil.exibirJanelaInformativa(context, 'Esqueceste-te do teu lugar? Andas com a cabeça no ar!', 'Zona: $zona Lugar: $lugar');
        } else {
          DialogoUtil.exibirJanelaInformativa(context,'Nenhum estacionamento ativo', 'Você não possui um estacionamento ativo no momento.');
        }
      } catch (e) {
        DialogoUtil.exibirJanelaInformativa(context,'Erro', 'Não foi possível buscar as informações de estacionamento: $e');
      }
    } else {
      DialogoUtil.exibirJanelaInformativa(context,'Usuário não logado', 'Por favor, faça login para ver os detalhes do estacionamento.');
    }
  }
}
