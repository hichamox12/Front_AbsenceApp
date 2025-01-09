import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/absence.dart';

class AbsencesScreen extends StatefulWidget {
  @override
  _AbsencesScreenState createState() => _AbsencesScreenState();
}

class _AbsencesScreenState extends State<AbsencesScreen> {
  List<Map<String, dynamic>> absences = [];
  List<Map<String, dynamic>> filteredAbsences = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAbsences();
  }

  Future<void> fetchAbsences() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/api/absences'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        setState(() {
          absences = data
              .map((absence) => {
            "id": absence['id_absence'], // Fetch the correct ID from backend
            "name": "${absence['prenom_etudiant']} ${absence['nom_etudiant']}",
            "percentage": "N/A", // Placeholder for percentage logic
            "status": absence['etat_abs'] ?? 'Unknown',
          })
              .toList();
          filteredAbsences = absences; // Initialize filtered list
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showError('Failed to fetch absences: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError('Error fetching absences: $e');
    }
  }

  void _filterAbsences(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredAbsences = absences; // Show all if query is empty
      } else {
        filteredAbsences = absences
            .where((absence) =>
            absence["name"].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _updateStatus(int index, String status) async {
    try {
      final id = filteredAbsences[index]['id'];
      if (id == null) {
        showError('Error: Absence ID is null');
        return;
      }

      final response = await http.put(
        Uri.parse('http://localhost:5000/api/absences/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"etat_abs": status}),
      );

      if (response.statusCode == 200) {
        setState(() {
          final originalIndex =
          absences.indexWhere((absence) => absence['id'] == id);
          absences[originalIndex]["status"] = status;
          filteredAbsences[index]["status"] = status;
        });
      } else {
        showError('Failed to update status: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error updating status: $e');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Liste des Absences',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : absences.isEmpty
          ? const Center(child: Text("No absences found."))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search for a student...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: _filterAbsences,
              ),
            ),
            // Absences Data Table
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Absences',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                  rows: filteredAbsences.map((absence) {
                    int index = filteredAbsences.indexOf(absence);
                    return DataRow(
                      cells: [
                        DataCell(Text(absence["name"])),
                        DataCell(Text(
                          absence["percentage"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan,
                          ),
                        )),
                        DataCell(
                          GestureDetector(
                            onTap: () {
                              showAbsenceModal(
                                context: context,
                                studentName: absence["name"],
                                attendancePercentage: 0.0, // Placeholder
                                onUpdate: (status) {
                                  _updateStatus(index, status);
                                },
                              );
                            },
                            child: Center(
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor:
                                _getStatusColor(absence["status"]),
                                child: Text(
                                  absence["status"][0],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            // Submit and Stats Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle submit action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // Handle stats action
                  },
                  icon: const Icon(Icons.pie_chart,
                      color: Colors.pinkAccent),
                  label: const Text(
                    "Stats",
                    style: TextStyle(
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.pinkAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Present":
        return Colors.cyan;
      case "Absent":
        return Colors.pink;
      case "Retard":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

void showAbsenceModal({
  required BuildContext context,
  required String studentName,
  required double attendancePercentage,
  required Function(String status) onUpdate,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    builder: (context) {
      return AbsenceModal(
        studentName: studentName,
        attendancePercentage: attendancePercentage,
        onUpdate: onUpdate,
      );
    },
  );
}
