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
