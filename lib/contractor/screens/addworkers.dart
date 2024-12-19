import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Worker Model (to hold worker information)
class Worker {
  final String workerId;
  final String name;
  final String dob;
  final String gender;
  final String phone;
  final String email;
  final String deviceToken;
  final String? assigned; // Added to track assigned contractor

  Worker({
    required this.workerId,
    required this.name,
    required this.dob,
    required this.gender,
    required this.phone,
    required this.email,
    required this.deviceToken,
    this.assigned,
  });

  // Convert a Worker object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dob': dob,
      'gender': gender,
      'phone': phone,
      'email': email,
      'deviceToken': deviceToken,
      'assigned': assigned, // Keep assigned field in Firestore
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
      assigned: data['assigned'], // Retrieve assigned field
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
  bool isLoading = true; // Track loading state

  // Fetch unassigned workers (workers where 'assigned' field is null or missing)
  Future<void> fetchUnassignedWorkers() async {
    try {
      // Fetch all workers from the Firestore collection
      QuerySnapshot snapshot = await _firestore.collection('Worker').get();

      // Filter workers where 'assigned' is null or an empty string
      setState(() {
        workers = snapshot.docs
            .where((doc) => doc['assigned'] == null || doc['assigned'] == "")
            .map((doc) => Worker.fromFirestore(doc))
            .toList();
        isLoading = false; // Data has been fetched, stop loading
      });
    } catch (e) {
      print("Error fetching workers: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load workers: $e'),
      ));
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUnassignedWorkers(); // Fetch workers when the page loads
  }

  // Function to send request and add a notification
  void sendRequest(Worker worker) async {
    try {
      User? user = FirebaseAuth.instance.currentUser; // Get the current user
      if (user == null) return;

      // Fetch contractor's details using the current user's UID
      DocumentSnapshot contractorSnapshot = await FirebaseFirestore.instance
          .collection('Contractor')
          .doc(user.uid)
          .get();

      // Check if contractor document exists and get the name
      String contractorName = contractorSnapshot.exists
          ? contractorSnapshot.get('name') ?? 'Unknown Contractor'
          : 'Unknown Contractor';

      // Create a notification with the workerId and contractorName
      await _firestore.collection('notifications').add({
        'workerName': worker.name,
        'message': 'You have a new job request from $contractorName.',
        'workerId': worker.workerId,
        'timestamp': FieldValue.serverTimestamp(),
        'contractorId': user.uid, // Send contractor's UID in the notification
        'contractorName': contractorName, // Add contractor name in notification
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
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              ) // Show loading indicator while fetching data
            : workers.isEmpty
                ? const Center(
                    child: Text(
                      'No Workers Available',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ) // Show message after data is fetched
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

// WorkerCard Widget to display worker information
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
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
