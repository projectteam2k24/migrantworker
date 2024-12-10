import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:migrantworker/contractor/screens/homepage.dart';
import 'package:migrantworker/job_provider/screens/homepage.dart';
import 'package:migrantworker/worker/screens/homepage.dart';

class LoginServiceFire {
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreDatabse = FirebaseFirestore.instance;

  Future<void> LoginService({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Sign in with email and password
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      

      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful')),
        );
        final role = await firestoreDatabse
            .collection('role_tb')
            .where('uid', isEqualTo: userCredential.user?.uid)
            .get();

        final roledata = role.docs.first.data();

        switch (roledata['role']) {
          case 'worker':
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WorkerHome(),
                ));
            break;
          case 'contractor':
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContractorHome(),
                ));
            break;
          case 'job_provider':
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JobProviderHome(),
                ));
            break;
        }

        // Optionally, navigate to another screen after successful login
        // Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    }
  }
}
