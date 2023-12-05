import 'package:flutter/material.dart';

class AdicionarMatricula extends StatefulWidget {
  const AdicionarMatricula({Key? key}) : super(key: key);

  @override
  _AdicionarMatriculaState createState() => _AdicionarMatriculaState();
}

class _AdicionarMatriculaState extends State<AdicionarMatricula> {
  final TextEditingController modeloController = TextEditingController();
  bool isMatriculaPortuguesa = true;
  bool isCarroEletrico = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar matrícula'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dados do veículo:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: modeloController,
              decoration: InputDecoration(
                labelText: 'Modelo: exemplo Audi A3',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Matrícula portuguesa'),
              value: isMatriculaPortuguesa,
              onChanged: (bool? value) {
                setState(() {
                  isMatriculaPortuguesa = value ?? false;
                });
              },
              secondary: const Icon(Icons.flag, color: Color(0xFF69285F)),
              checkColor: Colors.white, // color of tick Mark
              activeColor: Color(0xFF69285F),
            ),
            CheckboxListTile(
              title: Text('Carro elétrico'),
              value: isCarroEletrico,
              onChanged: (bool? value) {
                setState(() {
                  isCarroEletrico = value ?? false;
                });
              },
              secondary: const Icon(Icons.power, color: Color(0xFFA33564)),
              checkColor: Colors.white, // color of tick Mark
              activeColor: Color(0xFFA33564),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implemente a lógica de adicionar a matrícula aqui
              },
              child: Text('Adicionar'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF301B5A), // background
                onPrimary: Colors.white, // foreground
              ),
            ),
          ],
        ),
      ),
    );
  }
}