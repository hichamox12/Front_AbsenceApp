import 'package:flutter/material.dart';

class AbsencesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Absences'),
      ),
      body: DataTable(
        columns: const [
          DataColumn(label: Text('Nom')),
          DataColumn(label: Text('Absences')),
          DataColumn(label: Text('Statut')),
        ],
        rows: const [
          DataRow(cells: [
            DataCell(Text('Samuel Peterson')),
            DataCell(Text('10%')),
            DataCell(Text('A')),
          ]),
        ],
      ),
    );
  }
}
