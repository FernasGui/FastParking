import 'package:flutter/material.dart';
import 'package:fastparking/historico/obterHistoricoEstacionamento.dart';

class HistoricoPage extends StatefulWidget {
  @override
  _HistoricoPageState createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  List<Map<String, dynamic>> historico = [];

  @override
  void initState() {
  super.initState();
  obterHistoricoEstacionamento((novoHistorico) => atualizarUIComHistorico(novoHistorico));
}

  void atualizarUIComHistorico(List<Map<String, dynamic>> novoHistorico) {
    setState(() {
      historico = novoHistorico;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        backgroundColor: Color.fromRGBO(163, 53, 101, 1),
        foregroundColor: Color.fromRGBO(255, 255, 255, 1),
      ),
      body: Column(
        children: <Widget>[
          // Aqui você coloca o logo
          Padding(
            padding: const EdgeInsets.all(8.0), // Ajuste o espaçamento conforme necessário
            child: Image.asset('imagens/logo.png', width: 225, height: 150),
          ),
          // Aqui começa a tabela
          Expanded(
              
              child: DataTable(
                dataRowHeight: 90,
                columnSpacing: 20.0,
                columns: [
                  DataColumn(
                    label: Container(
                      width: 35,
                       // Tente ajustar este valor
                      child: Text('Data'),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: 65, 
                      child: Text('Parque'),
                    ),
                    
                  ),
                  DataColumn(
                    label: Container(
                      width: 48, // Tente ajustar este valor
                      child: Text('Entrada'),
                    ),
                  ),
                   DataColumn(
                    label: Container(
                      width: 48, // Tente ajustar este valor
                      child: Text('Saída'),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: 45, // Tente ajustar este valor
                      child: Text('Preço'),
                    ),
                  ),
                  
                  
                ],
                rows: historico.map((registro) {
                  return DataRow(
  cells: <DataCell>[
    DataCell(
      SizedBox(
        height: 50, // Defina a altura desejada para a linha
        child: Center(child: Text(registro['data'])),
      ),
    ),
    DataCell(
      SizedBox(
        height: 70,
        child: Center(child: Text(registro['nomeParque'], style: TextStyle(fontSize: 13))),
      ),
    ),
    DataCell(
      SizedBox(
        height: 50,
        child: Center(child: Text(registro['entrada'])),
      ),
    ),
    DataCell(
      SizedBox(
        height: 50,
        child: Center(child: Text(registro['saida'])),
      ),
    ),
    DataCell(
      SizedBox(
        height: 50,
        child: Center(child: Text(registro['preco'])),
      ),
    ),
  ],
);
                }).toList(),
              
              ),
            ),
        ],
      ),
    );
  }
}
