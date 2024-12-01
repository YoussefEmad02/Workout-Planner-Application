import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';
import 'signup_screen.dart'; // Navigate to sign-up screen
import 'workout_history_screen.dart'; // Navigate to workout history screen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Muscle Temple Gym"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular Avatar for Logo
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/logo.jpg'), // Replace with your logo asset path
                backgroundColor: Colors.blueAccent.shade100,
              ),
              SizedBox(height: 20),
              Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Please log in to continue",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: Validators.validateEmail,
                    ),
                    SizedBox(height: 15),
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: Validators.validatePassword,
                    ),
                    SizedBox(height: 20),
                    // Error Message
                    if (_errorMessage != null) ...[
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 10),
                    ],
                    // Login Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String? result = await AuthService().login(
                            _emailController.text,
                            _passwordController.text,
                          );
                          if (result == null) {
                            // Navigate to Workout Plan History Screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutHistoryScreen(
                                  userId: AuthService().currentUser?.uid ?? '',
                                ),
                              ),
                            );
                          } else {
                            setState(() {
                              _errorMessage = result;
                            });
                          }
                        }
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Navigate to Sign-Up
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      child: Text(
                        "Don't have an account? Sign up",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
