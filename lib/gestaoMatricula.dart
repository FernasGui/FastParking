import 'package:fastparking/adicionarMatricula.dart';
import 'package:flutter/material.dart';

class GestaoMatricula extends StatefulWidget {
  const GestaoMatricula({Key? key}) : super(key: key);

  @override
  _GestaoMatriculaState createState() => _GestaoMatriculaState();
}

class _GestaoMatriculaState extends State<GestaoMatricula> {
  // Lista de matrículas para o exemplo
  final List<Map<String, String>> matriculas = [
    {
      'matricula': '57-JA-33',
      'descricao': 'Mercedes E350',
    },
    {
      'matricula': '15-ML-92',
      'descricao': 'Hyundai i40',
    },
    // Adicione mais matrículas conforme necessário
  ];

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GESTÃO DE MATRÍCULAS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navegar para a página de adicionar matrícula
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AdicionarMatricula()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Inserir o logo aqui
          Padding(
            padding: const EdgeInsets.only(top: 16.0), // Ajuste o espaçamento conforme necessário
            child: Image.asset('imagens/logo.png', height: 200), // Ajuste o tamanho conforme necessário
          ),
          Expanded(
            child: ListView.builder(
              itemCount: matriculas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: Text(matriculas[index]['matricula'] ?? ''),
                  subtitle: Text(matriculas[index]['descricao'] ?? ''),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Lógica para quando o tile é tocado
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