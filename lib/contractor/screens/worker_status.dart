import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:migrantworker/contractor/screens/assignWorker.dart';
import 'package:migrantworker/contractor/screens/viewIncident.dart';
import 'package:migrantworker/contractor/screens/viewfeedback.dart';
import 'package:migrantworker/contractor/screens/homepage.dart';

class WorkerStatusPage extends StatefulWidget {
  const WorkerStatusPage({super.key});

  @override
  State<WorkerStatusPage> createState() => _WorkerStatusPageState();
}

class _WorkerStatusPageState extends State<WorkerStatusPage> {
  Map<String, String> providerNames = {};

  @override
  void initState() {
    super.initState();
    _fetchJobProviders();
  }

  Future<void> _fetchJobProviders() async {
    final providerDocs =
        await FirebaseFirestore.instance.collection('Job Provider').get();
    setState(() {
      for (var doc in providerDocs.docs) {
        providerNames[doc.id] = doc.get('name') ?? 'Unknown';
      }
    });
  }

  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    double widthFactor = MediaQuery.of(context).size.width;
    double heightFactor = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const ContractorHome();
              },
            ));
          },
        ),
        title: const Text(
          "Worker Status",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        elevation: 6,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(widthFactor * 0.04),
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('AssignedJobs').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No assigned jobs available.'));
            }

            final jobs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                final jobProviderUid = job['jobProviderUid'];
                final currentProgress = job['progress']?.toDouble() ?? 0.0;
                bool isCompleted = currentProgress == 100.0;
                String status = isCompleted
                    ? "Completed"
                    : (currentProgress > 0.0 ? "In Progress" : "Not Started");
                final providerName =
                    providerNames[jobProviderUid] ?? 'Loading...';

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: EdgeInsets.only(bottom: heightFactor * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(widthFactor * 0.04),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.all(widthFactor * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          providerName,
                          style: TextStyle(
                            fontSize: widthFactor * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                        SizedBox(height: heightFactor * 0.01),
                        Text(
                          "Current Job: ${job['jobType']}",
                          style: TextStyle(
                            fontSize: widthFactor * 0.045,
                            color: Colors.green[800],
                          ),
                        ),
                        SizedBox(height: heightFactor * 0.015),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status:",
                              style: TextStyle(
                                fontSize: widthFactor * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                fontSize: widthFactor * 0.045,
                                color: isCompleted
                                    ? Colors.green[700]
                                    : (currentProgress > 0.0
                                        ? Colors.orange[700]
                                        : Colors.red[700]),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: heightFactor * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Completion:",
                              style: TextStyle(
                                fontSize: widthFactor * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${currentProgress.toInt()}%",
                              style: TextStyle(
                                fontSize: widthFactor * 0.045,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: currentProgress,
                          min: 0.0,
                          max: 100.0,
                          divisions: 100,
                          activeColor: Colors.green,
                          inactiveColor: Colors.green.withOpacity(0.3),
                          label: "${currentProgress.toInt()}%",
                          onChanged: isCompleted
                              ? null // Disable slider if work is completed
                              : (double newValue) async {
                                  await FirebaseFirestore.instance
                                      .collection('AssignedJobs')
                                      .doc(job.id)
                                      .update({
                                    'progress': newValue,
                                    'status': newValue == 100.0
                                        ? "Completed"
                                        : (newValue > 0.0
                                            ? "In Progress"
                                            : "Not Started"),
                                  });
                                  setState(() {});
                                },
                        ),
                        SizedBox(height: heightFactor * 0.02),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: isCompleted
                                  ? null // Disable button if completed
                                  : () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AssignWorkerPage(
                                            jobId: job.id,
                                            contractorId: currentUser,
                                          ),
                                        ),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isCompleted ? Colors.grey : Colors.blue,
                              ),
                              child: Text(
                                isCompleted ? 'Completed' : 'Assign Worker',
                                style: TextStyle(fontSize: widthFactor * 0.045),
                              ),
                            ),
                            const SizedBox(width: 19),
                            ElevatedButton(
                              onPressed: () {
                                _viewIncident();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 0, 0),
                              ),
                              child: const Text('View Incident'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _viewIncident() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ViewIncidentsPage(),
      ),
    );
  }
}
