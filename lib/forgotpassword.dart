import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text.trim().toLowerCase();

    if (email.isEmpty) {
      _showMessage("Please enter your email.");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // 🔍 Step 1: Check if email exists in any collection
      bool emailExists = await _isEmailRegistered(email);

      if (!emailExists) {
        _showMessage("Email not registered. Please enter a valid email.");
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 🔍 Step 2: Send password reset email
      await _auth.sendPasswordResetEmail(email: email);
      _showMessage("Password reset email sent! Check your inbox.",
          success: true);
    } catch (e) {
      _showMessage("Error: ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _isEmailRegistered(String email) async {
    List<String> collections = ["Contractor", "Worker", "Job Provider"];

    for (String collection in collections) {
      QuerySnapshot query = await _firestore
          .collection(collection)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return true; // Email found in at least one collection
      }
    }
    return false; // Email not found in any collection
  }

  void _showMessage(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter your email to reset password",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _resetPassword,
                    child: Text("Reset Password"),
                  ),
          ],
        ),
      ),
    );
  }
}
