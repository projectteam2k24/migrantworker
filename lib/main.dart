import 'package:flutter/material.dart';
import 'package:migrantworker/contractor/screens/homepage.dart';
import 'package:migrantworker/job_provider/screens/homepage.dart';
import 'package:migrantworker/job_provider/screens/notification.dart';
import 'package:migrantworker/job_provider/screens/workingstatus.dart';
import 'package:migrantworker/worker/screens/homepage.dart';

void main() {
  runApp(
      const MaterialApp(debugShowCheckedModeBanner: false, home: WorkerHome()));
}
