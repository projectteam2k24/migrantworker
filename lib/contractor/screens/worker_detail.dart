import 'package:flutter/material.dart';
import 'package:migrantworker/worker/screens/registration.dart';

class WorkerDetailsPage extends StatefulWidget {
  @override
  _WorkerDetailsPageState createState() => _WorkerDetailsPageState();
}

class _WorkerDetailsPageState extends State<WorkerDetailsPage> {
  // State to track if the FAB is expanded
  bool isExpanded = false;

  // Sample list of workers for demonstration
  final List<Map<String, String>> workers = [
    {
      'fullName': 'John Doe',
      'dob': '1990-01-01',
      'gender': 'Male',
      'phone': '+1 234 567 890',
      'email': 'john.doe@example.com',
    },
    {
      'fullName': 'Jane Smith',
      'dob': '1992-05-10',
      'gender': 'Female',
      'phone': '+1 987 654 321',
      'email': 'jane.smith@example.com',
    },
    {
      'fullName': 'David Johnson',
      'dob': '1988-03-15',
      'gender': 'Male',
      'phone': '+1 111 222 333',
      'email': 'david.johnson@example.com',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workers',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: workers.length,
        itemBuilder: (context, index) {
          final worker = workers[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Name: ${worker['fullName'] ?? ''}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'DOB: ${worker['dob'] ?? ''}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Gender: ${worker['gender'] ?? ''}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Phone: ${worker['phone'] ?? ''}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Email: ${worker['email'] ?? ''}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // Button for New Worker
          if (isExpanded)
            Positioned(
              bottom: 90,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterWorker()),
                  );
                },
                heroTag: 'newWorker',
                backgroundColor: Colors.green,
                child: const Icon(Icons.person_add),
              ),
            ),
          // Button for Existing Worker
          if (isExpanded)
            Positioned(
              bottom: 159,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  print("Already Existing Worker selected");
                  // Add navigation logic for existing worker here
                },
                heroTag: 'existingWorker',
                backgroundColor: Colors.green,
                child: const Icon(Icons.group),
              ),
            ),
          // Main FAB
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded; // Toggle expansion
                });
              },
              heroTag: 'main',
              backgroundColor: Colors.green,
              child:
                  isExpanded ? const Icon(Icons.close) : const Icon(Icons.add),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
