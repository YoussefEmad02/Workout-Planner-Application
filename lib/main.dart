import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart'; // Import the login screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Planner', // App title
      theme: ThemeData(primarySwatch: Colors.blue), // Theme
      home: LoginScreen(), // Starting screen
      routes: { // Define app routes
        '/login': (context) => LoginScreen(),
        // Add other routes here (e.g., sign-up, workout screens)
      },
    );
  }
}
