import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobProviderFirebaseAuthService {
  final firebaseAuth = FirebaseAuth.instance;

  final firestoreDatabse = FirebaseFirestore.instance;

  Future<void> jobProviderReg(
      {required String name,
      required String phone,
      required String email,
      required String address,
      required String userType,
      required String password,
      File? profile,
      required BuildContext context}) async {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      
      firestoreDatabse.collection('Job Provider').doc(user.user?.uid).set({
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
        'userType': userType,
        'password': password,
      });

      firestoreDatabse
          .collection('role_tb')
          .add({'uid': user.user?.uid, 'role': 'job_provider'});
      
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Registration Successful')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Registration failed')));
    }
  }
}
