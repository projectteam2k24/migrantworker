import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class WorkerAuthService {
  final firebaseAuth = FirebaseAuth.instance;
  void workerReg(
      {required String name,
      required String dob,
      required String gender,
      required String phone,
      required String email,
      required String address,
      required String emergencyContact,
      required int duration,
      required String password,
      required String skill,
      required String salary,
      String? experience,
      required String languages,
      required File govtID,
      required File AddressProof,
      File? profile,
      required BuildContext context}) {
    try {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration Successful')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration failed')));
    }
  }
}
