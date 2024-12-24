import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewCurrentJobPage extends StatefulWidget {
  const ViewCurrentJobPage({super.key});

  @override
  State<ViewCurrentJobPage> createState() => _ViewCurrentJobPageState();
}

class _ViewCurrentJobPageState extends State<ViewCurrentJobPage> {
  bool isLoading = true;
  Map<String, dynamic>? jobDetails;

  @override
  void initState() {
    super.initState();
    _fetchCurrentJobDetails();
  }

  Future<void> _fetchCurrentJobDetails() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Fetch the worker's assigned job from AssignedWorkers collection
      final assignedWorkerSnapshot = await FirebaseFirestore.instance
          .collection('AssignedWorkers')
          .where('workerId', isEqualTo: currentUser.uid)
          .limit(1)
          .get();

      if (assignedWorkerSnapshot.docs.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final assignedJob = assignedWorkerSnapshot.docs.first.data();
      final jobId = assignedJob['jobId'];

      // Fetch the job details from AssignedJobs collection
      final jobSnapshot = await FirebaseFirestore.instance
          .collection('AssignedJobs')
          .doc(jobId)
          .get();

      if (!jobSnapshot.exists) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      setState(() {
        jobDetails = jobSnapshot.data();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching job details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'View Current Job',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // Navigate to the previous page
            },
          ),
          title: const Text(
            'Current Job Details',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Times New Roman',
            ),
          ),
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : jobDetails == null
                ? const Center(child: Text('No current job assigned.'))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCard('Job Details', [
                            _buildDetailItem(
                                'Job Type', jobDetails!['jobType'] ?? ''),
                            _buildDetailItem(
                                'Progress', '${jobDetails!['progress']}%'),
                            _buildDetailItem(
                                'Status', jobDetails!['status'] ?? ''),
                          ]),
                          const SizedBox(height: 16),
                          _buildCard('Location Details', [
                            _buildDetailItem(
                                'District', jobDetails!['district'] ?? ''),
                            _buildDetailItem(
                                'Address', jobDetails!['address'] ?? ''),
                          ]),
                          const SizedBox(height: 16),
                          _buildCard('Contact Details', [
                            _buildDetailItem(
                                'Contact Number', jobDetails!['contact'] ?? ''),
                          ]),
                          const SizedBox(height: 30),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                backgroundColor: Colors.green[700],
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Back to Dashboard',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
