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
          .get(const GetOptions(source: Source.server));

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

  Widget buildFeedbackSection(String contractorUid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('feedbacks')
          .where('contractorUid',
              isEqualTo: contractorUid) // Using contractor's UID
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Failed to load feedback. Please try again later.',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No feedback available.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final feedbacks = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: feedbacks.length,
          itemBuilder: (context, index) {
            final feedback = feedbacks[index];
            final data = feedback.data() as Map<String, dynamic>;

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade700,
                  backgroundImage: data['profileImage'] != null
                      ? NetworkImage(data['profileImage'])
                      : null,
                ),
                title: Text(data['jobProviderName'] ?? 'Anonymous'),
                subtitle: Text(data['message'] ?? 'No feedback provided.'),
              ),
            );
          },
        );
      },
    );
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

  Widget buildProfileSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: widget.profilePictureUrl != null
              ? NetworkImage(widget.profilePictureUrl!)
              : null,
          child: widget.profilePictureUrl == null
              ? const Icon(Icons.person, size: 50)
              : null,
        ),
        const SizedBox(height: 12),
        Text(widget.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(widget.jobType,
            style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }

  Widget buildInfoCard(
      IconData icon, String title, String value, VoidCallback? onTap) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        onTap: onTap,
      ),
    );
  }

  Widget buildCompanyDetailsCard() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.business, color: Colors.blue),
        title: const Text('Company Name',
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(widget.companyName),
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
            buildFeedbackSection(widget.contractorId),
            const SizedBox(height: 16),
            // Report Contractor Button
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

            // Send Request Button (Only for Workers)
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
}
