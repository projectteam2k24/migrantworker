import 'package:flutter/material.dart';
import 'package:migrantworker/job_provider/screens/edit_profile.dart';

class JobProviderProfile1 extends StatelessWidget {
  // Demo values for the profile
  final String fullName = 'John Doe';
  final String company = 'Tech Innovators Inc.';
  final String phone = '+1 234 567 890';
  final String email = 'john.doe@example.com';
  final String address = '123 Tech Lane, Silicon Valley';
  final String userType = 'Job Provider';
  final String password = '••••••'; // Hiding the password for security

  const JobProviderProfile1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        actions: [
          // Edit Icon Button at the top-right corner
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const EditProfilePage();
                },
              ));

              showDialog;
              (
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Edit Profile'),
                      content: const Text(
                          'Editing profile functionality goes here.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture with a circular container, shadow, and edit icon
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 120, // Profile picture size
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.green[50], // Soft light green background
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
                          radius: 60, // Radius of the profile picture
                          backgroundImage:
                              AssetImage('assets/profile_placeholder.png'),
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

              // Profile Header
              Center(
                child: Text(
                  'Job Provider Profile',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Personal Information Container with Elevated Card and Shadow
              Card(
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
                      _buildProfileItem('Full Name', fullName),
                      _buildProfileItem('Company', company),
                      _buildProfileItem('Phone Number', phone),
                      _buildProfileItem('Email Address', email),
                      _buildProfileItem('Address', address),
                      _buildProfileItem('User Type', userType),
                      _buildProfileItem('Password', password),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Logout Button with style
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Implement logout or other functionalities
                    Navigator.pop(
                        context); // Just an example, could be logout logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // More rounded
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    "Log Out",
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
        ),
      ),
    );
  }

  // Profile item builder for the personal information details
  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
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
}
