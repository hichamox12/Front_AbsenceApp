import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Login screen implementation
import 'screens/classes_screen.dart'; // Classes screen implementation
import 'screens/seance_screen.dart'; // Seance screen implementation
import 'screens/absences_screen.dart'; // Absences list screen implementation

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Absences',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // The initial route the app starts with
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(), // Remove const if LoginScreen doesn't support it
        '/classes': (context) => ClassesScreen(), // Remove const if needed
        '/seance': (context) => SeanceScreen(),
        '/absences': (context) => AbsencesScreen(),
      },
    );
  }
}
