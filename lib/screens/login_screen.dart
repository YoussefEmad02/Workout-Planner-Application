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
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: Validators.validateEmail,
              ),
              SizedBox(height: 10),
              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: Validators.validatePassword,
              ),
              SizedBox(height: 20),
              // Error Message
              if (_errorMessage != null) ...[
                Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                SizedBox(height: 10),
              ],
              // Login Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String? result = await AuthService()
                        .login(_emailController.text, _passwordController.text);
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
                child: Text("Log In"),
              ),
              // Navigate to Sign-Up
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
