import 'package:flutter/material.dart';
import 'package:migrantworker/login.dart';

class MyContractor extends StatefulWidget {
  const MyContractor({super.key});

  @override
  State<MyContractor> createState() => _MyContractorState();
}

class _MyContractorState extends State<MyContractor> {
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
              color: Colors.white, // Set the back button color to white
            ),
            onPressed: () {
              Navigator.pop(context); // Navigates to the previous page
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
        body: Container(
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
                      backgroundColor: Colors.green, // Set background color to green
                      child: Icon(
                        Icons.person_2_outlined,
                        size: 60, // Increased icon size
                        color: Colors.white, // Set the icon color to white
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'John Doe', // Contractor name
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Experienced Contractor', // Role or specialization
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
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
                  _buildProfileItem('Company Name', 'Doe Constructions'),
                  _buildProfileItem('Role/Position', 'Senior Contractor'),
                  _buildProfileItem('Experience', '15 Years'),
                  _buildProfileItem('Expertise', 'Carpentry, Electrical Work'),
                  const SizedBox(height: 20),
                ],
              ),
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
