import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class WorkerAuthService {
  final firebaseAuth = FirebaseAuth.instance;

  final firestoreDatabse = FirebaseFirestore.instance;

  Future<bool> workerReg(
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
      required String? govtID,
      required String? AddressProof,
      File? profile,
      required BuildContext context}) async {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      firestoreDatabse.collection('Worker').doc(user.user?.uid).set({
        'name': name,
        'dob': dob,
        'gender': gender,
        'phone': phone,
        'email': email,
        'address': address,
        'emergencyContact': emergencyContact,
        'duration': duration,
        'password': password,
        'skill': skill,
        'salary': salary,
        'experience': experience,
        'languages': languages,
        'govtID': govtID,
        'assigned': null
      });

      firestoreDatabse
          .collection('role_tb')
          .add({'uid': user.user?.uid, 'role': 'worker'});

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')));
      return true;
    } catch (e) {
      return false;
    }
  }
}
