import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/classes_screen.dart';
import 'screens/seance_screen.dart';
import 'screens/absences_screen.dart';

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
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/classes': (context) => ClassesScreen(),
        '/seance': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          if (args == null || !args.containsKey('classId') || !args.containsKey('groupId') || !args.containsKey('matiereId')) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(child: Text('Invalid navigation: classId, groupId, and matiereId are required.')),
            );
          }
          return SeanceScreen(
            classId: args['classId'],
            groupId: args['groupId'],
            matiereId: args['matiereId'],
          );
        },
        '/absences': (context) => AbsencesScreen(),
      },
    );
  }
}
