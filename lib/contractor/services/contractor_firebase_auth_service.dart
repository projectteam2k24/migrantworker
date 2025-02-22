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
      // Validation check for required document uploads
      if (govtID == null || companyCertificate == null || AddressProof == null) {
        showSnackbar(context, "All documents (Govt ID, Company Certificate, Address Proof) are required!", color: Colors.red);
        return;
      }

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

      showSnackbar(context, "Registration Successful", color: Colors.green);
    } catch (e) {
      showSnackbar(context, "Registration failed: ${e.toString()}", color: Colors.red);
    }
  }

  // Snackbar Function
  void showSnackbar(BuildContext context, String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: color ?? Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
