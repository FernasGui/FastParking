import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdicionarMatricula extends StatefulWidget {
  const AdicionarMatricula({Key? key}) : super(key: key);

  @override
  _AdicionarMatriculaState createState() => _AdicionarMatriculaState();
}

class _AdicionarMatriculaState extends State<AdicionarMatricula> {
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController matriculaController = TextEditingController();
  bool matriculaPortuguesa = false;
  bool carroEletrico = false;

  @override
  void dispose() {
    modeloController.dispose();
    matriculaController.dispose();
    super.dispose();
  }

 void _adicionarMatricula() async {
  // Verificar se os campos estão vazios
  if (modeloController.text.isEmpty || matriculaController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preencha todos os campos obrigatórios.'),
      backgroundColor: Colors.red),
      
    );
    return; // Parar a execução se algum campo estiver vazio
  }
  
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentReference docRef = FirebaseFirestore.instance.collection('Matriculas').doc(user.uid);

    Map<String, dynamic> veiculo = {
      'Descrição': modeloController.text,
      'Matricula': matriculaController.text,
      'Matricula Portuguesa': matriculaPortuguesa,
      'Carro Eletrico': carroEletrico,
    };

    await docRef.set({
      'veiculos': FieldValue.arrayUnion([veiculo]),
    }, SetOptions(merge: true)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Matrícula adicionada com sucesso!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar matrícula: $error')),
      );
    });

    // Limpar campos após a adição
    modeloController.clear();
    matriculaController.clear();
    setState(() {
        matriculaPortuguesa = false;
        carroEletrico = false;
      });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Você não está logado.')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Matrícula'),
        backgroundColor:  Color.fromRGBO(163, 53, 101, 1), 
        foregroundColor: Color.fromRGBO(255, 255, 255, 1),
       
        
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Image.asset('imagens/logo.png',  width: 200, height: 150), // Certifique-se de que o caminho para o seu logo está correto
            ),
          ),
            SizedBox(height: 20),
            TextField(
              controller: modeloController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                hintText: 'Exemplo: Audi A3',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: matriculaController,
              decoration: InputDecoration(
                labelText: 'Matrícula do veículo',
                hintText: 'Exemplo: 00-AB-00',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Matrícula portuguesa'),
              value: matriculaPortuguesa,
              onChanged: (bool? value) {
                setState(() {
                  matriculaPortuguesa = value ?? false;
                });
              },
              secondary: const Icon(Icons.flag, color: Color(0xFF69285F)),
              checkColor: Colors.white,
              activeColor: Color(0xFF69285F),
            ),
            CheckboxListTile(
              title: Text('Carro elétrico'),
              value: carroEletrico,
              onChanged: (bool? value) {
                setState(() {
                  carroEletrico = value ?? false;
                });
              },
              secondary: const Icon(Icons.power, color: Color(0xFFA33564)),
              checkColor: Colors.white,
              activeColor: Color(0xFFA33564),
            ),
            SizedBox(height: 16),
            Center(
              child: Container(
                width: 120, // Defina a largura do botão aqui
                child: ElevatedButton(
                  onPressed: _adicionarMatricula,
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
    );
  }
}
