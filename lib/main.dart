// ignore_for_file: unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:migrantworker/admin/homepage.dart';
import 'package:migrantworker/admin/viewreports.dart';
import 'package:migrantworker/chat_page.dart';
import 'package:migrantworker/contractor/screens/addworkers.dart';
import 'package:migrantworker/contractor/screens/homepage.dart';
import 'package:migrantworker/contractor/screens/profile.dart';
import 'package:migrantworker/contractor/screens/registration.dart';
import 'package:migrantworker/contractor/screens/viewIncident.dart';
import 'package:migrantworker/contractor/screens/worker_status.dart';
import 'package:migrantworker/firebase_options.dart';
import 'package:migrantworker/job_provider/screens/feedback.dart';
import 'package:migrantworker/job_provider/screens/homepage.dart';
import 'package:migrantworker/job_provider/screens/notification.dart';
import 'package:migrantworker/job_provider/screens/post_job.dart';
import 'package:migrantworker/job_provider/screens/profile.dart';
import 'package:migrantworker/job_provider/screens/search.dart';
import 'package:migrantworker/job_provider/screens/work_status.dart';
import 'package:migrantworker/login.dart';
import 'package:migrantworker/selectuser.dart';
import 'package:migrantworker/temp/aichat.dart';
import 'package:migrantworker/worker/screens/edit_profile.dart';
import 'package:migrantworker/worker/screens/homepage.dart';
import 'package:migrantworker/worker/screens/notification.dart';
import 'package:migrantworker/worker/screens/profile.dart';
import 'package:migrantworker/worker/screens/registration.dart';
import 'package:migrantworker/worker/screens/my_contractor.dart';
import 'package:migrantworker/worker/screens/reportmycontractor.dart';
import 'job_provider/screens/myjob.dart';

const apiKey = "AIzaSyB0o-xZfahxsiFkiIZ7TNkhkdRJcOjkoQE";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(apiKey: apiKey);
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: LogIn()));
}
