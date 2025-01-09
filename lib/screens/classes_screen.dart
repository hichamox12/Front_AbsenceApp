import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClassesScreen extends StatefulWidget {
  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  List<Map<String, dynamic>> classes = [];
  Map<int, List<Map<String, dynamic>>> groupesByClass = {};
  Map<int, List<Map<String, dynamic>>> matieresByClass = {};
  int? selectedGroupId;

  @override
  void initState() {
    super.initState();
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/api/classes'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          classes = List<Map<String, dynamic>>.from(data.map((item) => {
            'id': item['id_classe'],
            'name': item['nom_classe'],
          }));
        });
      } else {
        showError('Failed to fetch classes.');
      }
    } catch (e) {
      showError('Error fetching classes: $e');
    }
  }

  Future<void> fetchGroupes(int classId) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/api/groupes?classId=$classId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          groupesByClass[classId] = List<Map<String, dynamic>>.from(data.map((item) => {
            'id': item['id_groupe'],
            'professors': item['list_prof'] ?? 'No Professors',
            'classId': item['idClasseIdClasse'],
          })).where((group) => group['classId'] == classId).toList();
        });
      } else {
        showError('Failed to fetch groups for class $classId.');
      }
    } catch (e) {
      showError('Error fetching groups for class $classId: $e');
    }
  }

  Future<void> fetchMatieresByClass(int classId) async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/api/matieres?classId=$classId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          matieresByClass[classId] = List<Map<String, dynamic>>.from(data.map((item) => {
            'id': item['id_matiere'],
            'name': item['nom_module'],
            'classId': item['idClasseIdClasse'],
          })).where((matiere) => matiere['classId'] == classId).toList();
        });
      } else {
        showError('Failed to fetch matieres for class $classId.');
      }
    } catch (e) {
      showError('Error fetching matieres for class $classId: $e');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classes'),
        backgroundColor: Colors.cyan,
      ),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final classData = classes[index];
          final classId = classData['id'];
          final className = classData['name'];
          final groupes = groupesByClass[classId] ?? [];
          final matieresForClass = matieresByClass[classId] ?? [];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: Text(
                className,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onExpansionChanged: (expanded) {
                if (expanded) {
                  fetchGroupes(classId);
                  fetchMatieresByClass(classId);
                }
              },
              children: [
                ...groupes.map((groupe) {
                  final groupId = groupe['id'];
                  final professors = groupe['professors'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('Group $groupId'),
                        subtitle: Text('Professors: $professors'),
                      ),
                      ...matieresForClass.map((matiere) {
                        return ListTile(
                          title: Text(matiere['name']),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.pushNamed(context, '/seance', arguments: {
                              'classId': classId,
                              'groupId': groupId, // Pass the groupId dynamically
                              'matiereId': matiere['id'], // Pass the matiereId dynamically
                            });
                          },
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}