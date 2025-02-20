import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:migrantworker/worker/screens/reportmycontractor.dart';

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
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      var assignmentSnapshot = await FirebaseFirestore.instance
          .collection('assignments')
          .doc(user.uid)
          .get();

      if (assignmentSnapshot.exists) {
        String contractorId = assignmentSnapshot.data()?['contractorId'];

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

  Future<void> exchangeContractor() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      var workerSnapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .doc(user.uid)
          .get();

      if (!workerSnapshot.exists) {
        throw Exception('Worker data not found');
      }

      String workerName = workerSnapshot.data()?['name'] ?? 'Unknown Worker';
      String contractorId = workerSnapshot.data()?['assigned'] ?? 'Unknown Worker';

      await FirebaseFirestore.instance.collection('contractorNoti').add({
        'workerId': user.uid,
        'contractorId': contractorId,
        'message': "The $workerName wants to leave from your team",
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request sent to contractor successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error sending exchange request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send request'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showExchangeDialog(String contractorId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exchange Contractor'),
        content: const Text('Are you sure you want to leave this contractor?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              exchangeContractor();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
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
            String contractorId = contractorData['id'] ?? '';

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundImage: contractorData['profilePicture'] != null &&
                                contractorData['profilePicture'].isNotEmpty
                            ? NetworkImage(contractorData['profilePicture'])
                            : const AssetImage('assets/placeholder.png')
                                as ImageProvider,
                        radius: 55,
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
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          _buildProfileItem('Company Name',
                              contractorData['companyName'] ?? ''),
                          _buildProfileItem(
                              'Role/Position', contractorData['role'] ?? ''),
                          _buildProfileItem('Experience',
                              contractorData['experience'] ?? ''),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          String contractorName =
                              contractorData['name'] ?? 'Unknown Contractor';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportContractorPage(
                                contractorName: contractorName,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Report Contractor'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => showExchangeDialog(contractorId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Exchange Contractor'),
                      ),
                    ),
                  ],
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
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green)),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
        ],
      ),
    );
  }
}
