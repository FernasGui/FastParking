import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastparking/matricula/adicionarMatricula.dart';
import 'package:fastparking/matricula/editarMatricula.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class GestaoMatricula extends StatefulWidget {
  const GestaoMatricula({Key? key}) : super(key: key);

  @override
  _GestaoMatriculaState createState() => _GestaoMatriculaState();
}

class _GestaoMatriculaState extends State<GestaoMatricula> {
  final List<Map<String, dynamic>> veiculos = [];
  StreamSubscription<DocumentSnapshot>? matriculasSubscription;

  @override
  void initState() {
    super.initState();
    _iniciarListenerMatriculas();
  }

  void _iniciarListenerMatriculas() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      matriculasSubscription = FirebaseFirestore.instance
          .collection('Matriculas')
          .doc(user.uid)
          .snapshots()
          .listen((docSnapshot) {
        if (docSnapshot.exists) {
          Map<String, dynamic> data = docSnapshot.data()!;
          if (data['veiculos'] != null) {
            setState(() {
              veiculos.clear();
              veiculos.addAll(List<Map<String, dynamic>>.from(data['veiculos']));
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    matriculasSubscription?.cancel(); // Cancela o listener quando o widget é desmontado
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      double topPadding = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Matrículas'),
        backgroundColor: Color.fromRGBO(163, 53, 101, 1),
        foregroundColor: Color.fromRGBO(255, 255, 255, 1),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AdicionarMatricula()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
         SizedBox(height: topPadding),
            Image.asset('imagens/logo.png', width: 200, height: 150),
            SizedBox(height: topPadding),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: veiculos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: Text(veiculos[index]['Matricula'] ?? 'Sem matrícula'),
                  subtitle: Text(veiculos[index]['Descrição'] ?? 'Sem descrição'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                   Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditarMatricula(veiculo: veiculos[index], veiculoIndex: index),
                        ),
                      );                
                   },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
