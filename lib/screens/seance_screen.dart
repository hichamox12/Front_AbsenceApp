import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Student {
  final int id; // Corrected: Added 'id' for the student
  final String name;
  final int? groupId;

  Student({required this.id, required this.name, this.groupId});
}

class SeanceScreen extends StatefulWidget {
  final int classId;
  final int groupId;
  final int matiereId;

  const SeanceScreen({
    Key? key,
    required this.classId,
    required this.groupId,
    required this.matiereId,
  }) : super(key: key);

  @override
  _SeanceScreenState createState() => _SeanceScreenState();
}

class _SeanceScreenState extends State<SeanceScreen> {
  List<Student> students = [];
  List<Map<String, dynamic>> swipeData = []; // Corrected: Use dynamic to include IDs
  int currentIndex = 0;
  bool isLoading = true;
  int? seanceId;

  @override
  void initState() {
    super.initState();
    createSeance();
  }

  Future<void> createSeance() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/seances'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idGroupeIdGroupe': widget.groupId,
          'idMatiereIdMatiere': widget.matiereId,
          'date_seance': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        seanceId = data['id_seance'];
        fetchStudents();
      } else {
        showError('Failed to create seance: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error creating seance: $e');
    }
  }

  Future<void> fetchStudents() async {
    try {
      final uri = Uri.parse('http://localhost:5000/api/seances/etudiants')
          .replace(queryParameters: {
        'classId': widget.classId.toString(),
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          if (data.isNotEmpty) {
            students = data.map<Student>((student) {
              return Student(
                id: student['id_etudiant'],
                name: '${student['prenom_etudiant']} ${student['nom_etudiant']}',
                groupId: student['idGroupeIdGroupe'],
              );
            }).toList();
          } else {
            students = [];
          }
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showError('Failed to fetch students: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError('Error: $e');
    }
  }

  void updateStatus(String status) {
    if (currentIndex < students.length) {
      final student = students[currentIndex];
      final existing = swipeData.indexWhere((entry) => entry['idEtudiantIdEtudiant'] == student.id);

      // Avoid duplicates in swipeData
      if (existing == -1) {
        setState(() {
          swipeData.add({
            'idEtudiantIdEtudiant': student.id,
            'etat_abs': status,
            'idSeanceIdSeance': seanceId,
          });
        });
      }

      setState(() {
        currentIndex++;

        if (currentIndex >= students.length) {
          submitAttendance();
        }
      });
    }
  }

  Future<void> submitAttendance() async {
    if (seanceId == null) {
      showError('Seance ID not found.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/absences'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(swipeData),
      );

      if (response.statusCode == 201) {
        showSummaryModal();
      } else {
        showError('Failed to submit attendance: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error submitting attendance: $e');
    }
  }

  void showSummaryModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Attendance Summary"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: swipeData.map((data) {
            final student = students.firstWhere((s) => s.id == data['idEtudiantIdEtudiant']);
            return ListTile(
              title: Text(student.name),
              subtitle: Text(data['etat_abs']),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double circleWidth = screenWidth * 0.3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Séance'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
          ? const Center(
        child: Text("No students found for the selected class/group."),
      )
          : GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! > 0) {
              updateStatus("Absent");
            } else if (details.primaryVelocity! < 0) {
              updateStatus("Present");
            }
          }
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: circleWidth,
                height: circleWidth,
                decoration: const BoxDecoration(
                  color: Colors.pink,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    "A",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: circleWidth,
                height: circleWidth,
                decoration: const BoxDecoration(
                  color: Colors.cyan,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    "P",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentIndex < students.length
                        ? students[currentIndex].name
                        : "All students processed!",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
