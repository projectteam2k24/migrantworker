import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContractorFirebaseAuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreDatabse = FirebaseFirestore.instance;

// Registration function
  Future<void> contractorReg({
    required String name,
    required String dob,
    required String gender,
    required String phone,
    required String email,
    required String password,
    required String companyName,
    required String role,
    String? experience,
    required String skill,
    required String? govtID,
    required String? companyCertificate,
    required String? AddressProof,
    String? profile,
    required BuildContext context,
  }) async {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      firestoreDatabse.collection('Contractor').doc(user.user?.uid).set({
        'name': name,
        'dob': dob,
        'gender': gender,
        'phone': phone,
        'email': email,
        'password': password,
        'skill': skill,
        'experience': experience,
        'govtID': govtID,
        'role': role,
        'address': AddressProof,
        'companyName': companyName,
        'companyCertificate': companyCertificate,
        'profilePicture': profile,
      });

      firestoreDatabse
          .collection('role_tb')
          .add({'uid': user.user?.uid, 'role': 'contractor'});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed')),
      );
    }
  }
}
