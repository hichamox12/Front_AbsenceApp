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
      // The initial route the app starts with
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/classes': (context) => ClassesScreen(),
        '/seance': (context) => SeanceScreen(),
        '/absences': (context) => AbsencesScreen(),
      },
    );
  }
}

// Example of how to add a Hamburger Menu to a screen
class BaseScreen extends StatelessWidget {
  final String title;
  final Widget child;

  const BaseScreen({required this.title, required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.pinkAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pinkAccent),
              child: Center(
                child: Text(
                  'Gestion des Absences',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Login'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            ListTile(
              leading: Icon(Icons.class_),
              title: Text('Classes'),
              onTap: () {
                Navigator.pushNamed(context, '/classes');
              },
            ),
            ListTile(
              leading: Icon(Icons.date_range),
              title: Text('Seance'),
              onTap: () {
                Navigator.pushNamed(context, '/seance');
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text('Absences'),
              onTap: () {
                Navigator.pushNamed(context, '/absences');
              },
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}
