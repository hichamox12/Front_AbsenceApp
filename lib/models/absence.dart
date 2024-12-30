import 'package:flutter/material.dart';

class AbsenceModal extends StatelessWidget {
  final String studentName;
  final double attendancePercentage;
  final Function(String status) onUpdate;

  AbsenceModal({
    required this.studentName,
    required this.attendancePercentage,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Update Absence Status",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Student: $studentName",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            "Attendance: ${attendancePercentage.toStringAsFixed(1)}%",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  onUpdate("Present");
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text("Present"),
              ),
              ElevatedButton(
                onPressed: () {
                  onUpdate("Absent");
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text("Absent"),
              ),
              ElevatedButton(
                onPressed: () {
                  onUpdate("Retard");
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text("Retard"),
              ),
            ],
          ),
        ],
      ),
    );
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
    shape: RoundedRectangleBorder(
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
