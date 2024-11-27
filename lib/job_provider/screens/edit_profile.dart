import 'package:flutter/material.dart';
import 'package:migrantworker/job_provider/screens/homepage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Initial values for the profile
  final TextEditingController fullNameController =
      TextEditingController(text: 'John Doe');
  final TextEditingController companyController =
      TextEditingController(text: 'Tech Innovators Inc.');
  final TextEditingController phoneController =
      TextEditingController(text: '+1 234 567 890');
  final TextEditingController emailController =
      TextEditingController(text: 'john.doe@example.com');
  final TextEditingController addressController =
      TextEditingController(text: '123 Tech Lane, Silicon Valley');
  final TextEditingController userTypeController =
      TextEditingController(text: 'Job Provider');

  @override
  Widget build(BuildContext context) {
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
          // Save Icon Button at the top-right corner
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Add save functionality here
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Profile Saved'),
                  content:
                      const Text('Your profile has been updated successfully.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const JobProviderHome();
                          },
                        ));
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
              // Profile Picture Section
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 120,
                      height:
                          120, // Fixed height for the profile picture container
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
              const SizedBox(
                  height: 30), // Increased space after the profile picture

              // Edit Profile Header
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
              const SizedBox(height: 30), // Increased space after the header

              // Editable Personal Information Container
              Card(
                elevation: 8,
                shadowColor: Colors.green.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      15.0), // Reduced padding for smaller containers
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEditableProfileItem(
                          'Full Name', fullNameController),
                      _buildEditableProfileItem('Company', companyController),
                      _buildEditableProfileItem(
                          'Phone Number', phoneController),
                      _buildEditableProfileItem(
                          'Email Address', emailController),
                      _buildEditableProfileItem('Address', addressController),
                      _buildEditableProfileItem(
                          'User Type', userTypeController),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                  height: 30), // Added space between the card and the button

              // Save Changes Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const JobProviderHome();
                      },
                    ));

                    showDialog;
                    (
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Profile Saved'),
                            content: const Text(
                                'Your changes have been saved successfully.'),
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

  // Editable Profile item builder with green border
  Widget _buildEditableProfileItem(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 15.0), // Reduced bottom margin between fields
      child: Align(
        alignment: Alignment.centerLeft, // Align all text fields to the left
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
            const SizedBox(
                height: 8), // Added some space between label and text field
            TextField(
              controller: controller,
              decoration: InputDecoration(
                filled:
                    true, // Fill the TextField with a light background color
                fillColor: Colors.white, // Background color inside the box
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.green[700]!),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8), // Reduced the height of the box
                hintText: 'Enter $label',
                hintStyle: TextStyle(
                  color: Colors.green[700], // Hint text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
