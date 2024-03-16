import 'package:flutter/material.dart';

class PriceTable extends StatelessWidget {
  final List<Map<String, String>> data;

  const PriceTable({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowColor: MaterialStateProperty.all(Color(0xFF69285f)), // Cor de fundo do cabeçalho
      columns: const <DataColumn>[
        DataColumn(
          label: Text(
            'Tempo',
            style: TextStyle(color: Colors.white), // Cor do texto do cabeçalho
          ),
        ),
        DataColumn(
          label: Text(
            'Preço',
            style: TextStyle(color: Colors.white), // Cor do texto do cabeçalho
          ),
        ),
      ],
      rows: data.map((item) {
        return DataRow(
          cells: <DataCell>[
            DataCell(Text(item['tempo']!)),
            DataCell(Text(item['preco']!)),
          ],
        );
      }).toList(),
    );
  }
}
