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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign out the user
  void _logOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LogIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = _auth.currentUser?.uid;

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
                  builder: (context) => const EditContractorProfile(),
                ),
              );
            },
          ),
        ],
      ),
      body: userId == null
          ? const Center(child: Text("No user is logged in"))
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Contractor')
                  .doc(userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data.'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('No data found.'));
                } else {
                  final profileData =
                      snapshot.data?.data() as Map<String, dynamic>;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Picture Section
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: profileData[
                                            'profilePicture'] !=
                                        null
                                    ? NetworkImage(
                                        profileData['profilePicture'])
                                    : const AssetImage(
                                            'assets/profile_placeholder.png')
                                        as ImageProvider,
                                backgroundColor: Colors.grey[300],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Name and Role
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
                                profileData['role'] ?? 'Experienced Contractor',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Personal Information
                        _buildInfoContainer(
                          'Personal Information',
                          [
                            _buildProfileItem(
                                'Full Name', profileData['name'] ?? 'N/A'),
                            _buildProfileItem(
                                'Date of Birth', profileData['dob'] ?? 'N/A'),
                            _buildProfileItem(
                                'Gender', profileData['gender'] ?? 'N/A'),
                            _buildProfileItem(
                                'Phone Number', profileData['phone'] ?? 'N/A'),
                            _buildProfileItem(
                                'Email Address', profileData['email'] ?? 'N/A'),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Professional Details
                        _buildInfoContainer(
                          'Professional Details',
                          [
                            _buildProfileItem('Company Name',
                                profileData['companyName'] ?? 'N/A'),
                            _buildProfileItem(
                                'Role/Position', profileData['role'] ?? 'N/A'),
                            _buildProfileItem('Experience',
                                profileData['experience'] ?? 'N/A'),
                            _buildProfileItem(
                                'Expertise', profileData['skill'] ?? 'N/A'),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Documents Section
                        _buildInfoContainer(
                          'Uploaded Documents',
                          [
                            _buildDocumentItem(
                                'Government-issued ID',
                                profileData['govtID'] == null
                                    ? 'Not Uploaded'
                                    : 'Uploaded'),
                            _buildDocumentItem(
                                'Company Reg. Certificate',
                                profileData['companyCertificate'] == null
                                    ? 'Not Uploaded'
                                    : 'Uploaded'),
                            _buildDocumentItem(
                                'Proof of Address',
                                profileData['address'] == null
                                    ? 'Not Uploaded'
                                    : 'Uploaded'),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Logout Button
                        Center(
                          child: ElevatedButton(
                            onPressed: _logOut,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              minimumSize: const Size(200, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
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
