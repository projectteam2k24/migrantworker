import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignWorkerPage extends StatefulWidget {
  final String jobId;

  const AssignWorkerPage({super.key, required this.jobId});

  @override
  _AssignWorkerPageState createState() => _AssignWorkerPageState();
}

class _AssignWorkerPageState extends State<AssignWorkerPage> {
  bool isLoading = true;
  List<Map<String, dynamic>> workers = [];
  Map<String, bool> assignedStatus =
      {}; // Track the assignment status of workers

  @override
  void initState() {
    super.initState();
    _fetchWorkers();
    _monitorJobProgress();
  }

  // Fetch all workers
  Future<void> _fetchWorkers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Worker').get();

      setState(() {
        workers = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id; // Include the document ID as the worker's UID
          assignedStatus[doc.id] =
              data['isAssigned'] ?? false; // Initialize status
          return data;
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching workers: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Method to assign a worker
  Future<void> _assignWorker(String workerId) async {
    try {
      if (workerId.isEmpty || widget.jobId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Worker ID or Job ID is invalid.')),
        );
        return;
      }

      final workerRef =
          FirebaseFirestore.instance.collection('Worker').doc(workerId);

      // Update the 'isAssigned' field to true
      await workerRef.update({'isAssigned': true});

      // Add the worker and job to the AssignedWorkers collection
      await FirebaseFirestore.instance.collection('AssignedWorkers').add({
        'workerId': workerId,
        'jobId': widget.jobId,
        'assignedAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        assignedStatus[workerId] = true; // Update the status locally
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Worker assigned successfully.')),
      );
    } catch (e) {
      print("Error assigning worker: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to assign worker.')),
      );
    }
  }

  // Monitor job progress and free assigned workers when completed
  void _monitorJobProgress() {
    FirebaseFirestore.instance
        .collection('AssignedJobs')
        .doc(widget.jobId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        double progress = snapshot['progress']?.toDouble() ?? 0.0;
        if (progress == 100.0) {
          _freeAssignedWorker();
        }
      }
    });
  }

  // Free assigned workers and delete their assignments
  Future<void> _freeAssignedWorker() async {
    for (final worker in workers) {
      String workerId = worker['id'];
      if (assignedStatus[workerId] == true) {
        try {
          // Update the worker's isAssigned field to false
          await FirebaseFirestore.instance
              .collection('Worker')
              .doc(workerId)
              .update({'isAssigned': false});

          // Delete the assignment from AssignedWorkers collection
          final assignmentSnapshot = await FirebaseFirestore.instance
              .collection('AssignedWorkers')
              .where('workerId', isEqualTo: workerId)
              .where('jobId', isEqualTo: widget.jobId)
              .get();

          for (final doc in assignmentSnapshot.docs) {
            await doc.reference.delete();
          }

          setState(() {
            assignedStatus[workerId] = false; // Update the status locally
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Worker is now free.')),
          );
        } catch (e) {
          print("Error freeing worker: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Worker'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : workers.isEmpty
              ? const Center(child: Text('No workers available.'))
              : ListView.builder(
                  itemCount: workers.length,
                  itemBuilder: (context, index) {
                    final worker = workers[index];
                    String workerId = worker['id'];
                    bool isAssigned = assignedStatus[workerId] ?? false;

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
                              const SizedBox(height: 15),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: isAssigned
                                      ? null
                                      : () => _assignWorker(workerId),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isAssigned ? Colors.grey : Colors.green,
                                  ),
                                  child: Text(
                                    isAssigned ? 'On Duty' : 'Assign',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
