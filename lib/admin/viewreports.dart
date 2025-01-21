import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class ViewReportScreen extends StatelessWidget {
  const ViewReportScreen({super.key});

  Future<List<Map<String, dynamic>>> fetchReports() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Fetch the 'Reports' collection from Firestore
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Reports').get();

    List<Map<String, dynamic>> reports = [];

    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final reportedByUid = data['reportedBy'];

      String? reporterName;

      // Fetch the reporter's name from "Job Provider" or "Worker" collections
      if (reportedByUid != null) {
        DocumentSnapshot? jobProviderSnapshot = await FirebaseFirestore.instance
            .collection('Job Provider')
            .doc(reportedByUid)
            .get();

        if (jobProviderSnapshot.exists) {
          reporterName = jobProviderSnapshot['name'];
        } else {
          DocumentSnapshot? workerSnapshot = await FirebaseFirestore.instance
              .collection('Worker')
              .doc(reportedByUid)
              .get();

          if (workerSnapshot.exists) {
            reporterName = workerSnapshot['name'];
          }
        }
      }

      // Add the fetched name to the report
      reports.add({
        ...data,
        'reportedByName': reporterName ?? 'Unknown',
      });
    }

    return reports;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Reports'),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchReports(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reports found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final report = snapshot.data![index];
              return ReportCard(
                contractorName: report['reportedUser'] ?? 'Unknown',
                date: report['timestamp']?.toDate().toString() ?? 'N/A',
                incidentDescription:
                    report['comment'] ?? 'No description available',
                injuries: report['type']?.toString() ?? '0',
                jobProviderName: report['reportedByName'] ?? 'Unknown',
                onTap: () {
                  // Handle the tap event for detailed view
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final String contractorName;
  final String date;
  final String incidentDescription;
  final String injuries;
  final String jobProviderName;
  final VoidCallback onTap;

  const ReportCard({
    super.key,
    required this.contractorName,
    required this.date,
    required this.incidentDescription,
    required this.injuries,
    required this.jobProviderName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TYPE: $injuries',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Incident Description: $incidentDescription',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Reported User: $contractorName',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Reported By: $jobProviderName',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
