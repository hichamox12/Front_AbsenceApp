import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: AbsencesScreen()));
}

class AbsencesScreen extends StatefulWidget {
  @override
  _AbsencesScreenState createState() => _AbsencesScreenState();
}

class _AbsencesScreenState extends State<AbsencesScreen> {
  final List<Map<String, dynamic>> absences = [
    {"name": "Samuel Peterson", "percentage": "76%", "status": "P"},
    {"name": "Jane Doe", "percentage": "0%", "status": "A"},
    {"name": "John Smith", "percentage": "10%", "status": "R"},
    {"name": "Emily Davis", "percentage": "10%", "status": "P"},
    {"name": "Michael Brown", "percentage": "10%", "status": "A"},
  ];

  void _updateStatus(int index, String status) {
    setState(() {
      absences[index]["status"] = status;
    });
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
      body: Padding(
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
                              showCustomModal(
                                context: context,
                                studentName: absence["name"],
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
                                  absence["status"],
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
                    padding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 40),
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
                  icon: Icon(Icons.pie_chart, color: Colors.pinkAccent),
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
      case "P":
        return Colors.cyan;
      case "A":
        return Colors.pink;
      case "R":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class CustomModal extends StatelessWidget {
  final String studentName;
  final Function(String status) onUpdate;

  CustomModal({
    required this.studentName,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xFFDFF8FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close, color: Colors.black),
              ),
            ),
            SizedBox(height: 16),
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 50,
              child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            Text(
              studentName,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(context, "P", Colors.cyan, () {
                  onUpdate("P");
                  Navigator.of(context).pop();
                }),
                _buildButton(context, "A", Colors.pink, () {
                  onUpdate("A");
                  Navigator.of(context).pop();
                }),
                _buildButton(context, "R", Colors.orange, () {
                  onUpdate("R");
                  Navigator.of(context).pop();
                }),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle Edit action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Edit",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, Color color,
      VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

void showCustomModal({
  required BuildContext context,
  required String studentName,
  required Function(String status) onUpdate,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        child: CustomModal(
          studentName: studentName,
          onUpdate: onUpdate,
        ),
      );
    },
  );
}
