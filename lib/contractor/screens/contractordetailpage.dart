import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class ContractorAddetailPage extends StatefulWidget {
  final String contractorId; // Unique ID of the contractor
  final String name;
  final String jobType;
  final String phone;
  final String email;
  final String companyName;
  final String experience;
  final String skills;
  final String? profilePictureUrl; // Optional URL for the profile picture

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
    this.profilePictureUrl, // Optional URL parameter
  });

  @override
  State<ContractorAddetailPage> createState() => _ContractorAddetailPageState();
}

class _ContractorAddetailPageState extends State<ContractorAddetailPage> {
  late Map<String, dynamic> contractorData;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isReported = false; // Flag to check if contractor has been reported

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
      'profilePicture': widget.profilePictureUrl, // Add profile picture URL
    };
  }

  // Function to launch the phone dialer
  Future<void> _launchPhoneDialer(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phone';
    }
  }

  // Function to format timestamps
  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}';
  }

  // Function to report the contractor
  void _reportContractor() async {
    // Show a simple dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report Contractor'),
          content:
              const Text('Are you sure you want to report this contractor?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Add the report to Firestore
                await _firestore.collection('Reports').add({
                  'contractorId': widget.contractorId,
                  'reportedAt': FieldValue.serverTimestamp(),
                  'reportedBy': 'user', // Adjust this based on your user management
                });

                // Set the reported flag to true and disable the button
                setState(() {
                  isReported = true;
                });

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Contractor reported successfully.'),
                  ),
                );
              },
              child: const Text('Report'),
            ),
          ],
        );
      },
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
            // Profile Picture and Name
            buildProfileSection(),

            const SizedBox(height: 24),

            // Other Details (Phone, Email, Company Details, etc.)
            buildInfoCard(Icons.phone, 'Phone', contractorData['phone'], () {
              _launchPhoneDialer(contractorData['phone']);
            }),
            buildInfoCard(Icons.email, 'Email', contractorData['email'], () {
              // You can implement email functionality here if needed
            }),
            buildCompanyDetailsCard(),

            const SizedBox(height: 24),

            // Report Button Container with reduced size
            // Report Button Container with reduced width
            Container(
              color: Colors.red[50], // Light red color background
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: isReported ? null : _reportContractor, // Disable if already reported
                child: const Text('Report Contractor'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(
                    MediaQuery.of(context).size.width / 2,
                    48,
                  ), // Set width to half of the screen width
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Feedback Section
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('feedbacks')
                  .where('contractorUid', isEqualTo: widget.contractorId)
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
                          child: data['profileImage'] == null
                              ? Text(
                                  data['name'] != null &&
                                          data['name']!.isNotEmpty
                                      ? data['name']![0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(color: Colors.white),
                                )
                              : null,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['jobProviderName'] ?? 'Anonymous', // Job provider name
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: List.generate(5, (i) {
                                return Icon(
                                  i < (data['rating'] ?? 0)
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              }),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              data['message'] ?? 'No feedback provided.', // Feedback message
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Submitted on: ${_formatTimestamp(data['timestamp'])}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Profile Section with Profile Picture, Name, and Role (No Card used)
  Widget buildProfileSection() {
    return Column(
      children: [
        // Centered Profile Picture or Icon
        CircleAvatar(
          radius: 75, // Increased circle size for a more modern look
          backgroundColor: Colors.green[200],
          backgroundImage: contractorData['profilePicture'] != null &&
                  contractorData['profilePicture']!.isNotEmpty
              ? NetworkImage(contractorData['profilePicture']!)
              : null,
          child: contractorData['profilePicture'] == null ||
                  contractorData['profilePicture']!.isEmpty
              ? const Icon(
                  Icons.person,
                  size: 75,
                  color: Colors.white,
                )
              : null,
        ),
        const SizedBox(height: 16),
        // Name and Role (Job Type) below the profile picture with improved styling
        Text(
          contractorData['name'] ?? 'No name provided',
          style: const TextStyle(
            fontSize: 30, // Increased name size for more prominence
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          contractorData['jobType'] ?? 'No job type provided',
          style: TextStyle(
            fontSize: 18, // Adjusted size for job type
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  // General Info Card (Phone, Email, etc.)
  Widget buildInfoCard(
      IconData icon, String title, String content, Function() onTap) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: onTap, // Trigger the onTap callback
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.green[600], size: 28),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  content.isNotEmpty ? content : 'No $title provided',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Single Card for Company Details, Experience, and Skills
  Widget buildCompanyDetailsCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Company Name
            Text(
              'Company: ${contractorData['companyName']}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 16),

            // Display Experience
            Text(
              'Experience: ${contractorData['experience']}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),

            // Display Skills
            Text(
              'Skills: ${contractorData['skills']}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
