// ignore_for_file: unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:migrantworker/chat_page.dart';
import 'package:migrantworker/contractor/screens/homepage.dart';
import 'package:migrantworker/contractor/screens/registration.dart';
import 'package:migrantworker/contractor/screens/worker_status.dart';
import 'package:migrantworker/firebase_options.dart';
import 'package:migrantworker/job_provider/screens/homepage.dart';
import 'package:migrantworker/job_provider/screens/notification.dart';
import 'package:migrantworker/job_provider/screens/work_status.dart';
import 'package:migrantworker/login.dart';
import 'package:migrantworker/selectuser.dart';
import 'package:migrantworker/worker/screens/edit_profile.dart';
import 'package:migrantworker/worker/screens/notification.dart';
import 'package:migrantworker/worker/screens/registration.dart';
import 'job_provider/screens/myjob.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: LogIn()));
}
