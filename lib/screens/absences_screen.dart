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

  Future<void> _updateStatus(int index, String status) async {
    try {
      final id = absences[index]['id'];
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
          absences[index]["status"] = status;
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
        title: Text(
          'Liste des Absences',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : absences.isEmpty
          ? Center(child: Text("No absences found."))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filter and Search Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle filter action
                  },
                  icon: Icon(Icons.filter_list, color: Colors.white),
                  label: Text(
                    "Filter",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Absences Data Table
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text(
                        'Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Absences',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ],
                  rows: absences.map((absence) {
                    int index = absences.indexOf(absence);
                    return DataRow(
                      cells: [
                        DataCell(Text(absence["name"])),
                        DataCell(Text(
                          absence["percentage"],
                          style: TextStyle(
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
                                  style: TextStyle(
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
            SizedBox(height: 16),
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
                    padding: EdgeInsets.symmetric(
                        vertical: 12, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
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
                  icon: Icon(Icons.pie_chart,
                      color: Colors.pinkAccent),
                  label: Text(
                    "Stats",
                    style: TextStyle(
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.pinkAccent),
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
