import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:migrantworker/login.dart';
import 'package:migrantworker/worker/screens/edit_profile.dart';

class WorkerProfile extends StatefulWidget {
  const WorkerProfile({super.key});

  @override
  State<WorkerProfile> createState() => _WorkerProfileState();
}

class _WorkerProfileState extends State<WorkerProfile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Worker Profile',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Worker Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // Navigate to the previous screen
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const EditWorkerProfile();
                }));
              },
            ),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Worker')
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
              final profileData = snapshot.data!.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture with Shadow and Edit Icon
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.5),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 65,
                              backgroundImage: profileData['profilePic'] != null
                                  ? NetworkImage(profileData['profilePic'])
                                  : const AssetImage('assets/placeholder.png')
                                      as ImageProvider,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Worker Name and Role
                    Center(
                      child: Text(
                        profileData['name'] ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Skilled Worker',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // First Box: Personal Information
                    _buildBox(
                      title: 'Personal Information',
                      children: [
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
                        _buildProfileItem(
                            'Address', profileData['address'] ?? 'N/A'),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Second Box: Professional Details
                    _buildBox(
                      title: 'Professional Details',
                      children: [
                        _buildProfileItem('Emergency Contact Number',
                            profileData['emergencyContact'] ?? 'N/A'),
                        _buildProfileItem('Duration of Stay',
                            '${profileData['stayDuration'] ?? 0} Months'),
                        _buildProfileItem(
                            'Skill', profileData['skill'] ?? 'N/A'),
                        _buildProfileItem(
                            'Experience', profileData['experience'] ?? 'N/A'),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Third Box: Uploaded Documents
                    _buildBox(
                      title: 'Uploaded Documents',
                      children: [
                        _buildDocumentItem('Government-issued ID',
                            profileData['govtID'] == null ? 'Not Uploaded' : 'Uploaded'),
                        _buildDocumentItem('Proof of Address',
                            profileData['AddressProof'] == null ? 'Not Uploaded' : 'Uploaded'),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Log Out Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const LogIn();
                            },
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          minimumSize: const Size(200, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Log Out',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildBox({required String title, required List<Widget> children}) {
    return Container(
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
          _buildSectionTitle(title),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

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

  Widget _buildProfileItem(String label, dynamic value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          value != null ? value.toString() : 'N/A',  // ✅ Ensures it's a string
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    ),
  );
}


  Widget _buildDocumentItem(String label, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
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