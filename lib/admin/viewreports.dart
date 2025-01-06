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

    // Convert querySnapshot to a List of maps
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Reports'),
        backgroundColor: Colors.red.shade800, // accident/alert theme
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Add your refresh logic here
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Add your search logic here
            },
          ),
        ],
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
                contractorName: report['contractorName'] ?? 'Unknown',
                date: report['date'] ?? 'N/A',
                incidentDescription:
                    report['incidentDescription'] ?? 'No description available',
                injuries: report['injuries']?.toString() ?? '0',
                jobProviderName: report['jobProviderName'] ?? 'Unknown',
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
        color: Colors.red.shade50, // Accidents/fake theme
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contractor: $contractorName', // Null-safe check
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Date: $date', // Null-safe check
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Incident Description: $incidentDescription', // Null-safe check
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Injuries: $injuries', // Null-safe check
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Job Provider: $jobProviderName', // Null-safe check
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
