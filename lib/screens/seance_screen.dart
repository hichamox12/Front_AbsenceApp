import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Student {
  final int id;
  final String name;
  final String status; // "P" for Present, "A" for Absent

  Student({required this.id, required this.name, required this.status});
}

class SeanceScreen extends StatefulWidget {
  final int classId;
  final int groupId;
  final String subject;
  final int professorId; // ID of the professor teaching the subject
  final int seanceId; // ID of the specific seance

  const SeanceScreen({
    Key? key,
    required this.classId,
    required this.groupId,
    required this.subject,
    required this.professorId,
    required this.seanceId,
  }) : super(key: key);

  @override
  _SeanceScreenState createState() => _SeanceScreenState();
}

class _SeanceScreenState extends State<SeanceScreen> {
  List<Student> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:5000/api/seances/etudiants?classId=${widget.classId}&groupId=${widget.groupId}&subject=${widget.subject}&professorId=${widget.professorId}&seanceId=${widget.seanceId}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          students = List<Student>.from(data.map((student) {
            return Student(
              id: student['id_etudiant'],
              name:
              '${student['prenom_etudiant']} ${student['nom_etudiant']}',
              status: student['status'], // "P" or "A"
            );
          }));
          isLoading = false;
        });
      } else {
        showError('Failed to fetch students.');
      }
    } catch (e) {
      showError('Error: $e');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Séance Attendance'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
          ? const Center(child: Text('No students found.'))
          : ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Card(
            child: ListTile(
              title: Text(student.name),
              subtitle: Text('Status: ${student.status == "P" ? "Present" : "Absent"}'),
              leading: CircleAvatar(
                backgroundColor: student.status == "P"
                    ? Colors.green
                    : Colors.red,
                child: Text(
                  student.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
