import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getter for the current authenticated user
  User? get currentUser => _auth.currentUser;

  // Check if a user is logged in
  bool isLoggedIn() {
    return currentUser != null;
  }

  // Sign-up with email and password
  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // No errors
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase exceptions
      if (e.code == 'email-already-in-use') {
        return 'This email is already in use.';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email address.';
      } else if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else {
        return 'An unexpected error occurred: ${e.message}';
      }
    } catch (e) {
      return 'An error occurred: $e'; // General error
    }
  }

  // Log in with email and password
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // No errors
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase exceptions
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email address.';
      } else {
        return 'An unexpected error occurred: ${e.message}';
      }
    } catch (e) {
      return 'An error occurred: $e'; // General error
    }
  }

  // Log out
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }
}
