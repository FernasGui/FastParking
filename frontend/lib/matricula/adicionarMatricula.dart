import 'package:fastparking/formatMatricula.dart';
import 'package:fastparking/matricula/handlerMatriculas.dart';
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
  if (modeloController.text.isEmpty || matriculaController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preencha todos os campos obrigatórios.'), backgroundColor: Colors.red),
    );
    return;
  }

  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Você não está logado.'), backgroundColor: Colors.red),
    );
    return;
  }

  // Aqui, usamos a classe VehicleRegistration para criar um novo objeto veículo.
  final vehicleRegistration = VehicleRegistration(
    descricao: modeloController.text,
    matricula:  matriculaController.text,
    isPortuguese: matriculaPortuguesa,
    isElectric: carroEletrico,
  );

  // Acessa ou cria o documento para o usuário e adiciona a matrícula usando o método toJson() da classe VehicleRegistration.
  DocumentReference userDocRef = FirebaseFirestore.instance.collection('Matriculas').doc(user.uid);

  await userDocRef.set({
    'veiculos': FieldValue.arrayUnion([vehicleRegistration.toJson()]) // Usamos toJson() aqui
  }, SetOptions(merge: true)).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Matrícula adicionada com sucesso!'), backgroundColor: Colors.green),
    );
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao adicionar matrícula: $error'), backgroundColor: Colors.red),
    );
  });

  // Limpar campos após a adição
  modeloController.clear();
  matriculaController.clear();
  setState(() {
    matriculaPortuguesa = false;
    carroEletrico = false;
  });
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
              hintText: 'Exemplo: 00AB12',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            keyboardType: TextInputType.text,
            inputFormatters: [
              MatriculaInputFormatter(), // Usa o formatter personalizado
            ],
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
