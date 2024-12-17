import 'package:flutter/material.dart';

class ContractorAddetailPage extends StatefulWidget {
  final String contractorId; // Unique ID of the contractor
  final String name;
  final String address;
  final String jobType;
  final String description;
  final String companyName;
  final String phone;
  final String email;
  final String skills;

  const ContractorAddetailPage({
    super.key,
    required this.contractorId,
    required this.name,
    required this.address,
    required this.jobType,
    required this.description,
    required this.companyName,
    required this.phone,
    required this.email,
    required this.skills,
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
      'address': widget.address,
      'jobType': widget.jobType,
      'description': widget.description,
      'companyName': widget.companyName,
      'phone': widget.phone,
      'email': widget.email,
      'skills': widget.skills,
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
            buildProfileCard(),

            const SizedBox(height: 20),
            buildInfoCard(Icons.location_on, 'Address', contractorData['address']),
            buildInfoCard(Icons.email, 'Email', contractorData['email']),
            buildDescriptionCard(),
            buildInfoCard(Icons.business, 'Company Name', contractorData['companyName']),
            buildInfoCard(Icons.phone, 'Phone', contractorData['phone']),
            buildSkillsCard(),
          ],
        ),
      ),
    );
  }

  // Widget for Profile Card
  Widget buildProfileCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contractorData['name'] ?? 'No name provided',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contractorData['jobType'] ?? 'No job type provided',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // General Info Card
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

  // Description Card
  Widget buildDescriptionCard() {
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
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              contractorData['description'] ?? 'No description provided',
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

  // Skills Card
  Widget buildSkillsCard() {
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
            Text(
              widget.skills ?? 'No skill provided',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 8),
            
          ],
        ),
      ),
    );
  }
}
