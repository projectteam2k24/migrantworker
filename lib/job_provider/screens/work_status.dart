import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkingStatusPage extends StatefulWidget {
  const WorkingStatusPage({super.key});

  @override
  State<WorkingStatusPage> createState() => _WorkingStatusPageState();
}

class _WorkingStatusPageState extends State<WorkingStatusPage> {
  final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Working Status'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search jobs by type...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Job list
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('AssignedJobs')
                    .where('jobProviderUid', isEqualTo: currentUserUid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No assigned jobs available.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  // Filter jobs based on search query
                  final jobs = snapshot.data!.docs.where((job) {
                    final jobType = job['jobType']?.toString().toLowerCase();
                    return jobType != null && jobType.contains(searchQuery);
                  }).toList();

                  if (jobs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No jobs match your search.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      final contractorUid = job['contractorUid'];
                      final jobType = job['jobType'];
                      final progress = (job['progress'] ?? 0.0).toDouble();
                      final status = progress == 100.0
                          ? 'Completed'
                          : progress > 0.0
                              ? 'In Progress'
                              : 'Not Started';

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('Contractor')
                            .doc(contractorUid)
                            .get(),
                        builder: (context, contractorSnapshot) {
                          if (contractorSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          }

                          if (!contractorSnapshot.hasData ||
                              !contractorSnapshot.data!.exists) {
                            return const Center(
                                child: Text('Contractor details not found.'));
                          }

                          final contractorName =
                              contractorSnapshot.data!['name'] ?? 'Unknown';

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 12.0),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    jobType,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Icon(Icons.business,
                                          size: 18, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Contractor: $contractorName',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Icon(Icons.info,
                                          size: 18, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Status: $status',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: progress == 100.0
                                              ? Colors.green
                                              : progress > 0.0
                                                  ? Colors.orange
                                                  : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Adjusted width for the progress bar
                                  LinearProgressIndicator(
                                    value: progress /
                                        100, // Ensure value is between 0 and 1
                                    backgroundColor: Colors.grey[300],
                                    color: progress == 100.0
                                        ? Colors.green
                                        : progress > 0.0
                                            ? Colors.orange
                                            : Colors.red,
                                    minHeight: 6,
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '${(progress).toStringAsFixed(0)}% Completed',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
