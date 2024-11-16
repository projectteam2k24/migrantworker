import 'package:flutter/material.dart';

class ContractorProfile extends StatefulWidget {
  const ContractorProfile({super.key});

  @override
  State<ContractorProfile> createState() => _ContractorProfileState();
}

class _ContractorProfileState extends State<ContractorProfile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contractor Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Contractor Profile'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Navigate to edit profile page or enable editing
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile_placeholder.png'),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'John Doe', // Contractor name
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    'Experienced Contractor', // Role or specialization
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 30),
                _buildSectionTitle('Personal Information'),
                _buildProfileItem('Full Name', 'John Doe'),
                _buildProfileItem('Date of Birth', '12/12/1980'),
                _buildProfileItem('Gender', 'Male'),
                _buildProfileItem('Phone Number', '+1 234 567 8901'),
                _buildProfileItem('Email Address', 'johndoe@example.com'),
                _buildProfileItem('Address', '123 Main St, Springfield'),
                SizedBox(height: 20),
                _buildSectionTitle('Professional Details'),
                _buildProfileItem('Company Name', 'Doe Constructions'),
                _buildProfileItem('Role/Position', 'Senior Contractor'),
                _buildProfileItem('Experience', '15 Years'),
                _buildProfileItem('Expertise', 'Carpentry, Electrical Work'),
                SizedBox(height: 20),
                _buildSectionTitle('Uploaded Documents'),
                _buildDocumentItem('Government-issued ID', 'Uploaded'),
                _buildDocumentItem('Company Registration Certificate', 'Uploaded'),
                _buildDocumentItem('Proof of Address', 'Uploaded'),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Log out functionality
                    },
                    child: Text('Log Out'),
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
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
      padding: EdgeInsets.symmetric(vertical: 5.0),
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
