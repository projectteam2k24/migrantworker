import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,
    appBar: AppBar(backgroundColor: Colors.amberAccent,),
    body: Text("Hello", style: TextStyle(fontSize: 24, color: Colors.blue),));
  }
}