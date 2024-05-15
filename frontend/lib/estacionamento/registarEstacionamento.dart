import 'package:fastparking/dialogoUtil.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistarEstacionamento extends StatefulWidget {
  @override
  _RegistarEstacionamentoState createState() => _RegistarEstacionamentoState();
}

class _RegistarEstacionamentoState extends State<RegistarEstacionamento> {
  final _formKey = GlobalKey<FormState>();
  final _zonaController = TextEditingController();
  final _lugarController = TextEditingController();

Future<void> _registarEstacionamento() async {
 
 final user = FirebaseAuth.instance.currentUser;

if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Você não está logado.')),
    );
    return;
  }
  final estacionamentosAtivosQuery = await FirebaseFirestore.instance
      .collection('EstacionamentoAtivo')
      .where('UID', isEqualTo: user.uid)
      .get();

  if (estacionamentosAtivosQuery.docs.isNotEmpty) {
    // Atualizar estacionamento ativo existente
    final docId = estacionamentosAtivosQuery.docs.first.id;
    await FirebaseFirestore.instance.collection('EstacionamentoAtivo').doc(docId).update({
      'zona': _zonaController.text,
      'lugar': _lugarController.text,
      //'timestamp': FieldValue.serverTimestamp(), // Descomente se você quiser atualizar o timestamp também
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('O seu lugar foi guardado com sucesso.'),
      backgroundColor: Colors.green),

    );
    } else {
    DialogoUtil.exibirJanelaInformativa(
      context,
      'Atenção',
      'Não tens nenhum estacionamento ativo',
      );
    }
}

  @override
  void dispose() {
    _zonaController.dispose();
    _lugarController.dispose();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  double topPadding = MediaQuery.of(context).size.height * 0.01;
  return Scaffold(
    appBar: AppBar(
      title: Text('Registar Estacionamento'),
      backgroundColor: Color.fromRGBO(163, 53, 101, 1), 
      foregroundColor: Color.fromRGBO(255, 255, 255, 1),
    ),
    body: Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView( // Alterado para ListView para acomodar conteúdo que pode ser mais longo do que a tela
          children: <Widget>[
            SizedBox(height: 30),
            SizedBox(height: topPadding),
            Image.asset('imagens/logo.png', width: 150, height: 100),
            SizedBox(height: topPadding),
            
            SizedBox(height: 55), // Espaçamento entre o logo e o primeiro campo de texto
            TextFormField(
              controller: _zonaController,
              decoration: InputDecoration(
                labelText: 'Zona (Exemplo: F)',
                hintText: 'Insira a zona onde estacionou',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira a zona onde estacionou';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _lugarController,
              decoration: InputDecoration(
                labelText: 'Lugar (Exemplo: 27)',
                hintText: 'Insira o lugar onde estacionou',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o lugar onde estacionou';
                }
                return null;
              },
            ),
            SizedBox(height: 50.0),
          Center(
              child: Container(
                width: 120, // Defina a largura do botão aqui
                child: ElevatedButton(
                  onPressed: _registarEstacionamento,
                  child: Text('Guardar'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF69285F),
                    onPrimary: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

}