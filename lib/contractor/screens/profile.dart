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
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const EditContractorProfile();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Job Provider')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text('Error');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found.'));
          } else {
            final profileData = snapshot.data?.data() as Map<String, dynamic>;
            return ListView(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Picture with a circular container and edit icon
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
                                      backgroundImage: AssetImage(
                                          'assets/profile_placeholder.png'),
                                    ),
                                  ),
                                ),
                                // Edit icon inside the profile picture circle
                                IconButton(
                                  icon: const Icon(Icons.camera_alt),
                                  onPressed: () {
                                    // Handle image change functionality here
                                  },
                                  iconSize: 30,
                                  color: Colors.green[700],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Profile Name and Role
                          Center(
                            child: Text(
                              profileData['name'] ?? 'N/A', // Contractor name
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Experienced Contractor', // Role or specialization
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600]),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // First Container: Personal & Professional Details
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Personal Information'),
                                _buildProfileItem(
                                    'Full Name', profileData['name'] ?? 'N/A'),
                                _buildProfileItem('Date of Birth',
                                    profileData['dob'] ?? 'N/A'),
                                _buildProfileItem(
                                    'Gender', profileData['gender'] ?? 'N/A'),
                                _buildProfileItem('Phone Number',
                                    profileData['phone'] ?? 'N/A'),
                                _buildProfileItem('Email Address',
                                    profileData['email'] ?? 'N/A'),
                                _buildProfileItem(
                                    'Address', profileData['address'] ?? 'N/A'),
                                const SizedBox(height: 30),
                                _buildSectionTitle('Professional Details'),
                                _buildProfileItem('Company Name',
                                    'Doe Constructions'), // Placeholder for now
                                _buildProfileItem('Role/Position',
                                    'Senior Contractor'), // Placeholder for now
                                _buildProfileItem('Experience',
                                    profileData['experience'] ?? '0 Years'),
                                _buildProfileItem(
                                    'Expertise', profileData['skill'] ?? 'N/A'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Second Container: Documents Upload Section
                          Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionTitle('Uploaded Documents'),
                                _buildDocumentItem('Government-issued ID',
                                    profileData['govtID'] ?? 'Not Uploaded'),
                                _buildDocumentItem(
                                    'Company Registration Certificate',
                                    'Uploaded'), // Placeholder
                                _buildDocumentItem('Proof of Address',
                                    'Uploaded'), // Placeholder
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Log Out Button
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
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
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  // Profile section title builder
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green[700],
        ),
      ),
    );
  }

  // Profile item builder for personal details
  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
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

  // Document item builder
  Widget _buildDocumentItem(String label, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
