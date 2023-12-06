import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditarMatricula extends StatefulWidget {
  final Map<String, dynamic> veiculo;
  final int veiculoIndex;

  const EditarMatricula({Key? key, required this.veiculo, required this.veiculoIndex}) : super(key: key);

  @override
  _EditarMatriculaState createState() => _EditarMatriculaState();
}

class _EditarMatriculaState extends State<EditarMatricula> {
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  late bool _matriculaPortuguesa; // Inicializado no initState
  late bool _carroEletrico; // Inicializado no initState

  @override
  void initState() {
    super.initState();
    _matriculaController.text = widget.veiculo['Matricula'] ?? '';
    _descricaoController.text = widget.veiculo['Descrição'] ?? '';
    _matriculaPortuguesa = widget.veiculo['Matricula Portuguesa'] ?? false;
    _carroEletrico = widget.veiculo['Carro Eletrico'] ?? false;
  }

  @override
  void dispose() {
    _matriculaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _salvarAlteracoes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference docRef = FirebaseFirestore.instance.collection('Matriculas').doc(user.uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          throw Exception("Documento não existe!");
        }
        var veiculos = List<Map<String, dynamic>>.from(snapshot['veiculos']);

        // Atualiza o veículo no índice fornecido
        veiculos[widget.veiculoIndex] = {
          'Descrição': _descricaoController.text,
          'Matricula': _matriculaController.text,
          'Matricula Portuguesa': _matriculaPortuguesa,
          'Carro Eletrico': _carroEletrico,
        };

        transaction.update(docRef, {'veiculos': veiculos});
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Matrícula atualizada com sucesso!')),
        );
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar matrícula: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário não autenticado.')),
      );
    }
  }

  void _excluirMatricula() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference docRef = FirebaseFirestore.instance.collection('Matriculas').doc(user.uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        if (!snapshot.exists) {
          throw Exception("Documento não existe!");
        }
        var veiculos = List<Map<String, dynamic>>.from(snapshot['veiculos']);
        veiculos.removeAt(widget.veiculoIndex);

        transaction.update(docRef, {'veiculos': veiculos});
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Matrícula excluída com sucesso!')),
        );
        Navigator.of(context).pop();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir matrícula: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário não autenticado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Matrícula'),
        backgroundColor: Color.fromRGBO(163, 53, 101, 1),
        foregroundColor: Color.fromRGBO(255, 255, 255, 1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             SizedBox(height: 30),
           TextField(
              controller: _matriculaController,
              decoration: InputDecoration(
                labelText: 'Matrícula do veículo',
                hintText: 'Exemplo: 00-AB-00',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            
            SizedBox(height: 16),
                TextField(
              controller: _descricaoController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                hintText: 'Exemplo: Audi A3',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Matrícula portuguesa'),
              value: _matriculaPortuguesa,
              onChanged: (bool? value) {
                setState(() {
                  _matriculaPortuguesa = value ?? false;
                });
              },
              secondary: const Icon(Icons.flag, color: Color(0xFF69285F)),
              checkColor: Colors.white,
              activeColor: Color(0xFF69285F),
            ),
            CheckboxListTile(
              title: Text('Carro elétrico'),
              value: _carroEletrico,
              onChanged: (bool? value) {
                setState(() {
                  _carroEletrico = value ?? false;
                });
              },
              secondary: const Icon(Icons.power, color: Color(0xFFA33564)),
               checkColor: Colors.white,
              activeColor: Color(0xFFA33564),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _salvarAlteracoes,
              child: Text('Guardar Alterações'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF69285F),
                onPrimary: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: _excluirMatricula,
              child: Text('Eliminar Matrícula'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
