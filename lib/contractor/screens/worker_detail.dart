import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:migrantworker/contractor/screens/addworkers.dart';
import 'package:migrantworker/worker/screens/registration.dart';

class WorkerDetailsPage extends StatefulWidget {
  const WorkerDetailsPage({super.key});

  @override
  _WorkerDetailsPageState createState() => _WorkerDetailsPageState();
}

class _WorkerDetailsPageState extends State<WorkerDetailsPage> {
  bool isExpanded = false;
  bool isLoading = true; // Track loading state
  String? currentUserId;
  List<Map<String, dynamic>> workers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  // Fetch the current logged-in user's ID
  Future<void> _getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
      _fetchWorkersAssignedToUser(user.uid);
    }
  }

  // Fetch workers whose assigned field matches the current user's UID
  Future<void> _fetchWorkersAssignedToUser(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .where('assigned', isEqualTo: userId)
          .get();

      setState(() {
        workers = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id; // Store worker document ID
          return data;
        }).toList();
        isLoading = false; // Data has been fetched, stop loading
      });
    } catch (e) {
      print("Error fetching workers: $e");
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
    }
  }

  // Function to unassign a worker
  Future<void> _unassignWorker(String workerId) async {
    try {
      // Set the 'assigned' field of Worker collection to null
      await FirebaseFirestore.instance.collection('Worker').doc(workerId).update({
        'assigned': null,
      });

      // Set the 'contractorId' field of assignments collection to null
      await FirebaseFirestore.instance.collection('assignments').doc(workerId).update({
        'contractorId': null,
      });

      // Remove worker from the local list
      setState(() {
        workers.removeWhere((worker) => worker['id'] == workerId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Worker unassigned successfully')),
      );
    } catch (e) {
      print("Error unassigning worker: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to unassign worker')),
      );
    }
  }

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : workers.isEmpty
              ? const Center(child: Text('No workers assigned to you.'))
              : ListView.builder(
                  itemCount: workers.length,
                  itemBuilder: (context, index) {
                    final worker = workers[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
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
                                'Full Name: ${worker['name'] ?? ''}',
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
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _unassignWorker(worker['id']);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Delete'),
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
          if (isExpanded)
            Positioned(
              bottom: 90,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterWorker(),
                    ),
                  );
                },
                heroTag: 'newWorker',
                backgroundColor: Colors.green,
                child: const Icon(Icons.person_add),
              ),
            ),
          if (isExpanded)
            Positioned(
              bottom: 159,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddWorkers(),
                    ),
                  );
                },
                heroTag: 'existingWorker',
                backgroundColor: Colors.green,
                child: const Icon(Icons.group),
              ),
            ),
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
