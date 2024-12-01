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
      appBar: AppBar(title: Text("Sign Up")),
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
              // Sign-Up Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String? result = await AuthService()
                        .signUp(_emailController.text, _passwordController.text);
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
                child: Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
