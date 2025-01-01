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
    double screenWidth = MediaQuery.of(context).size.width;
    double circleWidth = screenWidth * 0.3; // 30% of the screen width

    return Scaffold(
      appBar: AppBar(
        title: Text('Séances'),
      ),
      body: currentIndex < students.length
          ? GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! > 0) {
              // Swiped right for Absent
              updateStatus("A");
            } else if (details.primaryVelocity! < 0) {
              // Swiped left for Present
              updateStatus("P");
            }
          }
        },
        child: Stack(
          children: [
            // Left Background (A)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: circleWidth,
                height: circleWidth,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "A",
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Glisser",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Right Background (P)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: circleWidth,
                height: circleWidth,
                decoration: BoxDecoration(
                  color: Colors.cyan,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "P",
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Glisser",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Student Information
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    students[currentIndex].name,
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
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
