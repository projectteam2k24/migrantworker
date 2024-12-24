import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyContractor extends StatefulWidget {
  const MyContractor({super.key});

  @override
  State<MyContractor> createState() => _MyContractorState();
}

class _MyContractorState extends State<MyContractor> {
  late Future<Map<String, dynamic>> contractorDetails;

  @override
  void initState() {
    super.initState();
    contractorDetails = fetchContractorDetails();
  }

  Future<Map<String, dynamic>> fetchContractorDetails() async {
    try {
      // Fetch the current user's UID
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Fetch the assignment for the current user
      var assignmentSnapshot = await FirebaseFirestore.instance
          .collection('assignments')
          .doc(user.uid) // Use current user's UID to fetch the assignment
          .get();

      if (assignmentSnapshot.exists) {
        String contractorId = assignmentSnapshot.data()?['contractorId'];

        // Fetch the contractor details using the contractor ID
        var contractorSnapshot = await FirebaseFirestore.instance
            .collection('Contractor')
            .doc(contractorId)
            .get();

        if (contractorSnapshot.exists) {
          return contractorSnapshot.data()!;
        }
      }
    } catch (e) {
      print('Error fetching contractor details: $e');
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Contractor',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'My Contractor',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Times New Roman',
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: contractorDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No contractor assigned"));
            }

            var contractorData = snapshot.data!;

            return Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.person_2_outlined,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          contractorData['name'] ?? 'No Name',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          contractorData['role'] ?? 'No Role',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildSectionTitle('Personal Information'),
                      _buildProfileItem(
                          'Full Name', contractorData['name'] ?? ''),
                      _buildProfileItem(
                          'Date of Birth', contractorData['dob'] ?? ''),
                      _buildProfileItem(
                          'Gender', contractorData['gender'] ?? ''),
                      _buildProfileItem(
                          'Phone Number', contractorData['phone'] ?? ''),
                      _buildProfileItem(
                          'Email Address', contractorData['email'] ?? ''),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Professional Details'),
                      _buildProfileItem(
                          'Company Name', contractorData['companyName'] ?? ''),
                      _buildProfileItem(
                          'Role/Position', contractorData['role'] ?? ''),
                      _buildProfileItem(
                          'Experience', contractorData['experience'] ?? ''),
                      _buildProfileItem(
                          'Expertise', contractorData['expertise'] ?? ''),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green,
          fontFamily: 'Times New Roman',
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
