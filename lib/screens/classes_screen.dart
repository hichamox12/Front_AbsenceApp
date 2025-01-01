import 'package:flutter/material.dart';

class ClassesScreen extends StatefulWidget {
  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final List<Map<String, dynamic>> classes = [
    {'name': '2ACI', 'modules': ['IHM', 'Statistique']},
    {'name': '3ACI', 'modules': ['Module 1', 'Module 2']},
    {'name': '1ACI', 'modules': <String>[]},
    {'name': '1INFO', 'modules': <String>[]},
    {'name': '2INFO', 'modules': <String>[]},
  ];

  // Track expanded classes
  Map<String, bool> expandedClasses = {};

  @override
  void initState() {
    super.initState();
    // Initialize all classes as collapsed
    for (var classData in classes) {
      expandedClasses[classData['name']] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
      ),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          String className = classes[index]['name'];
          List<String> modules = List<String>.from(classes[index]['modules']);
          bool isExpanded = expandedClasses[className] ?? false;

          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            color: Colors.cyan,

            child: Column(
              children: [
                ListTile(

                  title: Text(
                    className,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(
                    isExpanded ? Icons.keyboard_arrow_down : Icons.arrow_forward,
                  ),
                  onTap: () {
                    setState(() {
                      expandedClasses[className] = !isExpanded;
                    });
                  },
                ),
                if (isExpanded && modules.isNotEmpty)
                  Container(
                    color: Colors.grey[200],
                    child: Column(
                      children: modules
                          .map(
                            (module) => ListTile(
                          title: Text(module),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            // Navigate to the module details or actions
                          },
                        ),
                      )
                          .toList(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
