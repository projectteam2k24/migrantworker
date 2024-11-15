import 'package:flutter/material.dart';
import 'package:migrantworker/contractor/screens/registration.dart';
import 'package:migrantworker/job_provider/screens/registration.dart';
import 'package:migrantworker/worker/screens/registration.dart';

class SelectUser extends StatefulWidget {
  const SelectUser({super.key});

  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 150.0,
              left: 50.0,
            ),
            child: ElevatedButton(
              onPressed: () {},
              child: Icon(
                Icons.person_2_outlined,
                size: 100.0,
                color: Colors.green,
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150, 150),
              ),
            ),
          ),
          // Wrapping the text with Row to place next to the icons
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 55.0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.left,
              children: [
                Text(
                  'Welcome Guest',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 55.0),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.left,
              children: [
                Text(
                  'I am here as :)',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: GridView.count(
              crossAxisCount: 2, // Display items in a grid of two columns
              shrinkWrap: true,
              physics:
                  NeverScrollableScrollPhysics(), // Prevents scrolling issues
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              padding: EdgeInsets.symmetric(horizontal: 50),
              children: [
                // Worker Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterWorker(),));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.construction, size: 40, color: Colors.green),
                        SizedBox(height: 8),
                        Text(
                          "Worker",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                // Job Provider Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const RegisterJobProvider();
                    },));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.business_center,
                            size: 40, color: Colors.green),
                        SizedBox(height: 8),
                        Text(
                          "Job Provider",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                // Contractor Button
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return RegisterContractor();
                    },));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.handyman, size: 40, color: Colors.green),
                        SizedBox(height: 8),
                        Text(
                          "Contractor",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
