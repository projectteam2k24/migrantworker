import 'package:flutter/material.dart';
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
          backgroundColor: Colors.green[700],
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
                // Navigate to edit profile page or enable editing
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage('assets/profile_placeholder.png'),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'John Doe', // Worker name
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
                const Center(
                  child: Text(
                    'Skilled Worker', // Role or specialization
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 30),

                // First Container for Personal and Professional Information
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
                      _buildProfileItem('Full Name', 'John Doe'),
                      _buildProfileItem('Date of Birth', '12/12/1980'),
                      _buildProfileItem('Gender', 'Male'),
                      _buildProfileItem('Phone Number', '+1 234 567 8901'),
                      _buildProfileItem('Email Address', 'johndoe@example.com'),
                      _buildProfileItem('Address', '123 Main St, Springfield'),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Professional Details'),
                      _buildProfileItem(
                          'Emergency Contact Number', '+1 234 567 8901'),
                      _buildProfileItem(
                          'Duration of stay at Current Location in Months',
                          '14'),
                      _buildProfileItem('Skill', 'Plumbing'),
                      _buildProfileItem(
                          'Expertise', 'Plumbing, Electrical Work'),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Second Container for Uploaded Documents
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
                      _buildDocumentItem('Government-issued ID', 'Uploaded'),
                      _buildDocumentItem('Proof of Address', 'Uploaded'),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Log Out Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Log out functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Log Out'),
                  ),
                ),
              ],
            ),
          ),
        ),
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

  Widget _buildProfileItem(String label, String value) {
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
            value,
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
