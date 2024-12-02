import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              // Circular Avatar for Logo
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/logo.jpg'), // Replace with your logo asset path
                backgroundColor: Colors.blueAccent.shade100,
              ),
              SizedBox(height: 20),
              Text(
                "Create Your Account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Sign up to get started!",
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
                        filled: true,
                        fillColor: Colors.white, // Match page background color
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.black), // Black label text
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.grey), // Icon color changed to grey
                      ),
                      style: TextStyle(color: Colors.black), // Black input text
                      validator: Validators.validateEmail,
                    ),
                    SizedBox(height: 15),
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white, // Match page background color
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.black), // Black label text
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.grey), // Icon color changed to grey
                      ),
                      style: TextStyle(color: Colors.black), // Black input text
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
                    // Sign-Up Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.blueAccent), // Border for a button
                        ),
                        backgroundColor: Colors.white, // Button background white
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String? result = await AuthService().signUp(
                            _emailController.text,
                            _passwordController.text,
                          );
                          if (result == null) {
                            // Show "Account Created" message and navigate back to login
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Account created successfully!"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.pop(context); // Navigate back to login page
                            });
                          } else {
                            setState(() {
                              _errorMessage = result;
                            });
                          }
                        }
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 16, color: Colors.blueAccent), // Button text color blue
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to login page
                },
                child: Text(
                  "Already have an account? Log in",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
