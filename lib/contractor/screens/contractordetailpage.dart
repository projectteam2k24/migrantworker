import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:migrantworker/worker/screens/reportmycontractor.dart';
import 'package:url_launcher/url_launcher.dart';

class ContractorAddetailPage extends StatefulWidget {
  final String contractorId;
  final String name;
  final String jobType;
  final String phone;
  final String email;
  final String companyName;
  final String experience;
  final String skills;
  final String? profilePictureUrl;

  const ContractorAddetailPage({
    super.key,
    required this.contractorId,
    required this.name,
    required this.jobType,
    required this.phone,
    required this.email,
    required this.companyName,
    required this.skills,
    required this.experience,
    this.profilePictureUrl,
  });

  @override
  State<ContractorAddetailPage> createState() => _ContractorAddetailPageState();
}

class _ContractorAddetailPageState extends State<ContractorAddetailPage> {
  late Map<String, dynamic> contractorData;
  bool isWorker = false;
  bool canSendRequest = false;

  @override
  void initState() {
    super.initState();
    contractorData = {
      'name': widget.name,
      'jobType': widget.jobType,
      'companyName': widget.companyName,
      'phone': widget.phone,
      'email': widget.email,
      'skills': widget.skills,
      'experience': widget.experience,
      'profilePicture': widget.profilePictureUrl,
    };
    checkWorkerStatus();
  }

  Future<void> checkWorkerStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final workerDoc = await FirebaseFirestore.instance
          .collection('Worker')
          .doc(user.uid)
          .get();

      if (workerDoc.exists) {
        setState(() {
          isWorker = true;
          canSendRequest = workerDoc.data()?['assigned'] == null;
        });
      }
    }
  }

  Future<void> _sendRequestToContractor() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final workerDoc = await FirebaseFirestore.instance
          .collection('Worker')
          .doc(user.uid)
          .get();

      if (workerDoc.exists) {
        String workerName = workerDoc.data()?['name'] ?? 'Unknown Worker';

        await FirebaseFirestore.instance.collection('ContractorRequests').add({
          'workerId': user.uid,
          'contractorId': widget.contractorId,
          'workerName': workerName,
          'message': '$workerName wants to join your team',
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request sent successfully!')),
        );

        setState(() {
          canSendRequest = false; // Disable the button after sending request
        });
      }
    }
  }

  Future<void> _launchPhoneDialer(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phone';
    }
  }

  void _navigateToReportPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportContractorPage(
          contractorName: contractorData['name'] ?? 'No name provided',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contractor Details'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: ListView(
          children: [
            buildProfileSection(),
            const SizedBox(height: 24),
            buildInfoCard(Icons.phone, 'Phone', contractorData['phone'], () {
              _launchPhoneDialer(contractorData['phone']);
            }),
            buildInfoCard(Icons.email, 'Email', contractorData['email'], () {}),
            buildCompanyDetailsCard(),
            const SizedBox(height: 24),

            Container(
              color: Colors.red[50],
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _navigateToReportPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(MediaQuery.of(context).size.width / 2, 48),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Report Contractor'),
              ),
            ),

            const SizedBox(height: 16),

            // Show Send Request Button only for Workers with assigned == null
            if (isWorker)
              Container(
                color: Colors.blue[50],
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: canSendRequest ? _sendRequestToContractor : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize:
                        Size(MediaQuery.of(context).size.width / 2, 48),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: Text(
                    canSendRequest ? 'Send Request' : 'Request Sent',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 75,
          backgroundColor: Colors.green[200],
          backgroundImage: contractorData['profilePicture'] != null &&
                  contractorData['profilePicture']!.isNotEmpty
              ? NetworkImage(contractorData['profilePicture']!)
              : null,
          child: contractorData['profilePicture'] == null ||
                  contractorData['profilePicture']!.isEmpty
              ? const Icon(Icons.person, size: 75, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          contractorData['name'] ?? 'No name provided',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          contractorData['jobType'] ?? 'No job type provided',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget buildInfoCard(
      IconData icon, String title, String content, Function() onTap) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.green[600], size: 28),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  content.isNotEmpty ? content : 'No $title provided',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCompanyDetailsCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company: ${contractorData['companyName']}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700])),
            const SizedBox(height: 16),
            Text('Experience: ${contractorData['experience']}',
                style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            const SizedBox(height: 16),
            Text('Skills: ${contractorData['skills']}',
                style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }
}
