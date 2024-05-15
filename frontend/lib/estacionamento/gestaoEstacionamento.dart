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
            .collection('EstacionamentoAtivo')
            .where('UID', isEqualTo: user.uid)
            .limit(1)
            .get();

        if (estacionamentoSnapshot.docs.isNotEmpty) {
          final estacionamentoData = estacionamentoSnapshot.docs.first.data();
          final zona = estacionamentoData['zona'];
          final lugar = estacionamentoData['lugar'];
          if(zona == null || zona == null){
             DialogoUtil.exibirJanelaInformativa(context, 'Ainda não guardas-te o teu lugar', 'Vai a Registar Estacionamento no menu e diz-nos onde estacionaste o teu maquinão');
          }
          else{DialogoUtil.exibirJanelaInformativa(context, 'Esqueceste-te do teu lugar? Andas com a cabeça no ar!', 'Zona: $zona Lugar: $lugar');
          }
          
        } else {
          DialogoUtil.exibirJanelaInformativa(context,'Atenção', 'Não tens nenhum estacionamento ativo.');
        }
      } catch (e) {
        DialogoUtil.exibirJanelaInformativa(context,'Erro', 'Não foi possível buscar as informações de estacionamento: $e');
      }
    } else {
      DialogoUtil.exibirJanelaInformativa(context,'Usuário não logado', 'Por favor, faça login para ver os detalhes do estacionamento.');
    }
  }
}
