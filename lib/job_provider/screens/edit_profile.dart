import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:migrantworker/job_provider/screens/homepage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controllers for the profile fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController userTypeController = TextEditingController();

  bool isLoading = true; // For showing a loading indicator

  @override
  void initState() {
    super.initState();
    _fetchProfileDetails(); // Fetch the details when the page loads
  }

  Future<void> _fetchProfileDetails() async {
    try {
      // Get the current user's ID
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        // Fetch the user's document from Firestore
        final snapshot = await FirebaseFirestore.instance
            .collection('Job Provider') // Replace with your collection name
            .doc(userId)
            .get();

        if (snapshot.exists) {
          final data = snapshot.data();
          setState(() {
            // Populate the controllers with fetched data
            fullNameController.text = data?['name'] ?? '';
            phoneController.text = data?['phone'] ?? '';
            emailController.text = data?['email'] ?? '';
            addressController.text = data?['address'] ?? '';
            userTypeController.text = data?['userType'] ?? '';
            isLoading = false; // Data fetching complete
          });
        }
      } else {
        // Handle case where the user is not logged in
        setState(() {
          isLoading = false;
        });
        print('User is not logged in');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching profile details: $e');
    }
  }

  Future<void> _saveProfileDetails() async {
    try {
      // Get the current user's ID
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        // Update the user's document in Firestore
        await FirebaseFirestore.instance
            .collection('Job Provider') // Replace with your collection name
            .doc(userId)
            .set({
          'name': fullNameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'address': addressController.text,
          'userType': userTypeController.text,
        });

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Profile Saved'),
            content: const Text('Your profile has been updated successfully.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => const JobProviderHome(),
                  ));
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      } else {
        print('User is not logged in');
      }
    } catch (e) {
      print('Error saving profile details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show a loading indicator while data is being fetched
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          backgroundColor: Colors.green[700],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfileDetails, // Save functionality
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
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
                          backgroundImage:
                              AssetImage('assets/profile_placeholder.png'),
                        ),
                      ),
                    ),
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
              const SizedBox(height: 30),
              Center(
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 8,
                shadowColor: Colors.green.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEditableProfileItem(
                          'Full Name', fullNameController),
                      _buildEditableProfileItem(
                          'Phone Number', phoneController),
                      _buildEditableProfileItem(
                          'Email Address', emailController),
                      _buildEditableProfileItem('Address', addressController),
                      _buildUserTypeDropdown(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfileDetails,
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
                    "Save Changes",
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

  Widget _buildUserTypeDropdown() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'User Type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.green[700],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: userTypeController.text.isNotEmpty
              ? userTypeController.text
              : null,
          items: ['Personal', 'Company'].map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              userTypeController.text = value!;
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green[700]!),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildEditableProfileItem(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.green[700]!),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              hintText: 'Enter $label',
              hintStyle: TextStyle(color: Colors.green[700]),
            ),
          ),
        ],
      ),
    );
  }
}
