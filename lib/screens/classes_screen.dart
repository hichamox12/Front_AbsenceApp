import 'package:flutter/material.dart';

class ClassesScreen extends StatelessWidget {
  final List<String> classes = ['2ACI', '3ACI', '1ACI', '1INFO', '2INFO'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
      ),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(classes[index]),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to Seance screen
              },
            ),
          );
        },
      ),
    );
  }
}
