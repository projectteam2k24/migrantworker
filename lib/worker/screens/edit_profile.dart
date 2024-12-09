import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class EditWorkerProfile extends StatefulWidget {
  const EditWorkerProfile({super.key});

  @override
  State<EditWorkerProfile> createState() => _EditWorkerProfileState();
}

class _EditWorkerProfileState extends State<EditWorkerProfile> {
  // Controllers for text fields
  final TextEditingController _fullNameController =
      TextEditingController(text: 'John Doe');
  final TextEditingController _dobController =
      TextEditingController(text: '12/12/1980');
  final TextEditingController _genderController =
      TextEditingController(text: 'Male');
  final TextEditingController _phoneController =
      TextEditingController(text: '+1 234 567 8901');
  final TextEditingController _emailController =
      TextEditingController(text: 'johndoe@example.com');
  final TextEditingController _addressController =
      TextEditingController(text: '123 Main St, Springfield');
  final TextEditingController _companyNameController =
      TextEditingController(text: 'Doe Constructions');
  final TextEditingController _roleController =
      TextEditingController(text: 'Senior Contractor');
  final TextEditingController _experienceController =
      TextEditingController(text: '15 Years');
  final TextEditingController _expertiseController =
      TextEditingController(text: 'Carpentry, Electrical Work');

  // Image file for the profile picture
  File? _profileImage;

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _cropImage(pickedFile.path);
    }
  }

  // Crop the selected image
  Future<void> _cropImage(String imagePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.green,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Colors.green,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        _profileImage = File(croppedFile.path);
      });
    }
  }

  // Save handler
  void _saveProfile() {
    final updatedProfile = {
      'Full Name': _fullNameController.text,
      'Date of Birth': _dobController.text,
      'Gender': _genderController.text,
      'Phone Number': _phoneController.text,
      'Email': _emailController.text,
      'Address': _addressController.text,
      'Company Name': _companyNameController.text,
      'Role/Position': _roleController.text,
      'Experience': _experienceController.text,
      'Expertise': _expertiseController.text,
      'Profile Picture': _profileImage?.path ?? 'No image selected',
    };

    // Print updated profile (Replace with your API call)
    print('Updated Profile: $updatedProfile');

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : const AssetImage('assets/profile_placeholder.png')
                                as ImageProvider,
                        backgroundColor: Colors.grey[300],
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 18,
                          child: const Icon(Icons.edit,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Personal Details Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[50], // Light green background color
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.5), // Green shadow
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4), // Shadow position
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Full Name', _fullNameController),
                      _buildTextField('Date of Birth', _dobController),
                      _buildTextField('Gender', _genderController),
                      _buildTextField('Phone Number', _phoneController),
                      _buildTextField('Email Address', _emailController),
                      _buildTextField('Address', _addressController),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Professional Details Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[50], // Light green background color
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.5), // Green shadow
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4), // Shadow position
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Professional Details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      _buildTextField(
                          'Emergency Contact Number', _companyNameController),
                      _buildTextField(
                          'Duration of stay at Current Location in Months',
                          _roleController),
                      _buildTextField('Skill', _experienceController),
                      _buildTextField('Expertise', _expertiseController),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30), // Rounded borders
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}
