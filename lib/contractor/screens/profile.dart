import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:migrantworker/contractor/screens/edit_profile.dart';
import 'package:migrantworker/login.dart';

class ContractorProfile extends StatefulWidget {
  const ContractorProfile({super.key});

  @override
  State<ContractorProfile> createState() => _ContractorProfileState();
}

class _ContractorProfileState extends State<ContractorProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contractor Profile'),
        backgroundColor: Colors.green[750],
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditContractorProfile(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Contractor')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data.'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found.'));
          } else {
            final profileData = snapshot.data?.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture with Edit Icon
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const ClipOval(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  AssetImage('assets/profile_placeholder.png'),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () {
                            // Handle image change functionality
                          },
                          iconSize: 30,
                          color: Colors.green[700],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Contractor Name and Role
                  Center(
                    child: Column(
                      children: [
                        Text(
                          profileData['name'] ?? 'N/A',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        Text(
                          'Experienced Contractor',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Personal and Professional Information Section
                  _buildInfoContainer(
                    'Personal Information',
                    [
                      _buildProfileItem('Full Name', profileData['name'] ?? 'N/A'),
                      _buildProfileItem('Date of Birth', profileData['dob'] ?? 'N/A'),
                      _buildProfileItem('Gender', profileData['gender'] ?? 'N/A'),
                      _buildProfileItem('Phone Number', profileData['phone'] ?? 'N/A'),
                      _buildProfileItem('Email Address', profileData['email'] ?? 'N/A'),
                      _buildProfileItem('Address', profileData['address'] ?? 'N/A'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Professional Details Section
                  _buildInfoContainer(
                    'Professional Details',
                    [
                      _buildProfileItem(
                          'Company Name', profileData['companyName'] ?? 'N/A'),
                      _buildProfileItem('Role/Position',
                          profileData['role'] ?? 'Senior Contractor'),
                      _buildProfileItem(
                          'Experience', profileData['experience'] ?? '0 Years'),
                      _buildProfileItem(
                          'Expertise', profileData['skill'] ?? 'N/A'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Uploaded Documents Section
                  _buildInfoContainer(
                    'Uploaded Documents',
                    [
                      _buildDocumentItem(
                          'Government-issued ID', profileData['govtID'] ?? 'Not Uploaded'),
                      _buildDocumentItem(
                          'Company Reg. Certificate', 'Uploaded'), // Placeholder
                      _buildDocumentItem('Proof of Address', 'Uploaded'), // Placeholder
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Logout Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LogIn(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Builds a container for a section (e.g., Personal Info, Documents)
  Widget _buildInfoContainer(String title, List<Widget> children) {
    return Card(
      elevation: 8,
      shadowColor: Colors.green.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  // Builds a row for profile details (label and value)
  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builds a row for document status
  Widget _buildDocumentItem(String label, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 16,
              color: status == 'Uploaded' ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
