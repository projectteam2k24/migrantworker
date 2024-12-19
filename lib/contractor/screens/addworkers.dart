import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Worker Model (to hold worker information)
class Worker {
  final String workerId;
  final String name;
  final String dob;
  final String gender;
  final String phone;
  final String email;
  final String deviceToken;

  Worker({
    required this.workerId,
    required this.name,
    required this.dob,
    required this.gender,
    required this.phone,
    required this.email,
    required this.deviceToken,
  });

  // Convert a Worker object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dob': dob,
      'gender': gender,
      'phone': phone,
      'email': email,
      'deviceToken': deviceToken, // Store device token in Firestore
    };
  }

  // Create a Worker from a Firestore document
  factory Worker.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Worker(
      workerId: doc.id, // Firestore Document ID as workerId
      name: data['name'] ?? '',
      dob: data['dob'] ?? '',
      gender: data['gender'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      deviceToken: data['deviceToken'] ?? '',
    );
  }
}

class AddWorkers extends StatefulWidget {
  const AddWorkers({super.key});

  @override
  _AddWorkersState createState() => _AddWorkersState();
}

class _AddWorkersState extends State<AddWorkers> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Worker> workers = [];

  Future<void> fetchUnassignedWorkers() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Worker')
          .where('assigned', isEqualTo: null)
          .get();

      setState(() {
        workers =
            snapshot.docs.map((doc) => Worker.fromFirestore(doc)).toList();
      });
    } catch (e) {
      print("Error fetching workers: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load workers: $e'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUnassignedWorkers();
  }

  // Function to send request and add a notification
  void sendRequest(Worker worker) async {
    try {
      // Create a notification with the workerId as the document ID
      await _firestore.collection('notifications').add({
        'workerName': worker.name,
        'message': 'You have a new job request.',
        'workerId': worker.workerId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Request sent to ${worker.name}'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error sending request: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Workers to Team'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: workers.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: workers.length,
                itemBuilder: (context, index) {
                  final worker = workers[index];
                  return WorkerCard(worker: worker, onRequest: sendRequest);
                },
              ),
      ),
    );
  }
}

class WorkerCard extends StatelessWidget {
  final Worker worker;
  final Function(Worker) onRequest;

  const WorkerCard({super.key, required this.worker, required this.onRequest});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              worker.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
            ),
            const SizedBox(height: 8),
            Text("Date of Birth: ${worker.dob}"),
            Text("Gender: ${worker.gender}"),
            Text("Phone: ${worker.phone}"),
            Text("Email: ${worker.email}"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => onRequest(worker),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text(
                    "Send Request",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
