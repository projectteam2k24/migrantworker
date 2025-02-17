import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobProviderFirebaseAuthService {
  final firebaseAuth = FirebaseAuth.instance;

  final firestoreDatabse = FirebaseFirestore.instance;

  Future<bool> jobProviderReg(
      {required String name,
      required String phone,
      required String email,
      required String address,
      required String userType,
      required String password,
      String? profile,
      required BuildContext context}) async {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      firestoreDatabse.collection('Job Provider').doc(user.user?.uid).set({
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
        'userType': userType,
        'password': password,
        'profile': profile,
      });

      firestoreDatabse
          .collection('role_tb')
          .add({'uid': user.user?.uid, 'role': 'job_provider'});

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')));
      return true;
    } catch (e) {
      return false;
    }
  }
}
