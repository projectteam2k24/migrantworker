import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contractor Details'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Picture and Name
            buildProfileSection(),

            const SizedBox(height: 20),

            // Other Details (Phone, Email, Company Details, etc.)
            buildInfoCard(Icons.phone, 'Phone', contractorData['phone']),
            buildInfoCard(Icons.email, 'Email', contractorData['email']),
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
          radius: 60, // Increased circle size
          backgroundColor: Colors.green,
          backgroundImage: contractorData['profilePicture'] != null &&
                  contractorData['profilePicture']!.isNotEmpty
              ? NetworkImage(contractorData[
                  'profilePicture']!) // Load the image from the URL
              : null, // No background image if profile picture is null
          child: contractorData['profilePicture'] == null ||
                  contractorData['profilePicture']!.isEmpty
              ? const Icon(
                  Icons.person, // Default icon when no image is provided
                  size: 60,
                  color: Colors.white,
                )
              : null, // No icon when image is provided
        ),
        const SizedBox(height: 12),
        // Name and Role (Job Type) below the profile picture with increased size
        Text(
          contractorData['name'] ?? 'No name provided',
          style: const TextStyle(
            fontSize: 28, // Increased name size
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          contractorData['jobType'] ?? 'No job type provided',
          style: TextStyle(
            fontSize: 18, // Increased job type size
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  // General Info Card (Phone, Email, etc.)
  Widget buildInfoCard(IconData icon, String title, String content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.green),
            const SizedBox(width: 16),
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
    );
  }

  // Single Card for Company Details, Experience, and Skills
  Widget buildCompanyDetailsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Company Name
            Text(
              'Company: ${contractorData['companyName']}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 12),

            // Display Experience
            Text(
              'Experience: ${contractorData['experience']}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),

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
