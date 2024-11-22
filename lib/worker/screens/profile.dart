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
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Worker Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const EditWorkerProfile();
                },));
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
                    backgroundImage: AssetImage('assets/profile_placeholder.png'),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'John Doe', // Contractor name
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const Center(
                  child: Text(
                    'Experienced Contractor', // Role or specialization
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 30),
                _buildSectionTitle('Personal Information'),
                _buildProfileItem('Full Name', 'John Doe'),
                _buildProfileItem('Date of Birth', '12/12/1980'),
                _buildProfileItem('Gender', 'Male'),
                _buildProfileItem('Phone Number', '+1 234 567 8901'),
                _buildProfileItem('Email Address', 'johndoe@example.com'),
                _buildProfileItem('Address', '123 Main St, Springfield'),
                const SizedBox(height: 20),
                _buildSectionTitle('Professional Details'),
                _buildProfileItem('Emergency Contact Number', '+1 234 567 8901'),
                _buildProfileItem('Duration of stay at Current Location in Months', '14'),
                _buildProfileItem('Skill', '15 Years'),
                _buildProfileItem('Expertise', 'Carpentry, Electrical Work'),
                const SizedBox(height: 20),
                _buildSectionTitle('Uploaded Documents'),
                _buildDocumentItem('Government-issued ID', 'Uploaded'),
                _buildDocumentItem('Proof of Address', 'Uploaded'),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Log out functionality
                    },
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
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
