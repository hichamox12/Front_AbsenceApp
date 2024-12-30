import 'package:flutter/material.dart';

class Student {
  final String name;
  String status; // P for Present, A for Absent

  Student({required this.name, this.status = ''});
}

class SeanceScreen extends StatefulWidget {
  @override
  _SeanceScreenState createState() => _SeanceScreenState();
}

class _SeanceScreenState extends State<SeanceScreen> {
  List<Student> students = [
    Student(name: "Amrini Hicham"),
    Student(name: "Oussama Hajiri"),
    Student(name: "Yassine El Mansouri"),
  ];
  int currentIndex = 0;

  void updateStatus(String status) {
    setState(() {
      students[currentIndex].status = status;
      if (currentIndex < students.length - 1) {
        currentIndex++;
      } else {
        // All students have been processed
        showSummaryModal();
      }
    });
  }

  void showSummaryModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Attendance Summary"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: students.map((student) {
            return ListTile(
              leading: Icon(
                student.status == "P" ? Icons.check : Icons.close,
                color: student.status == "P" ? Colors.green : Colors.red,
              ),
              title: Text(student.name),
              subtitle: Text(
                student.status == "P" ? "Present" : "Absent",
                style: TextStyle(
                  color: student.status == "P" ? Colors.green : Colors.red,
                ),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Séances'),
      ),
      body: currentIndex < students.length
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            students[currentIndex].name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dx < 0) {
                // Swiped left for Absent
                updateStatus("A");
              } else if (details.delta.dx > 0) {
                // Swiped right for Present
                updateStatus("P");
              }
            },
            child: Container(
              height: 300,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.grey[700],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Swipe left for Absent, right for Present",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Icon(Icons.arrow_back, color: Colors.pink, size: 50),
                  Text(
                    "Absent",
                    style: TextStyle(
                        color: Colors.pink, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.arrow_forward, color: Colors.teal, size: 50),
                  Text(
                    "Present",
                    style: TextStyle(
                        color: Colors.teal, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      )
          : Center(
        child: Text(
          "All students have been marked!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
