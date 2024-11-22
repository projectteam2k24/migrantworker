import 'package:flutter/material.dart';

class EditContractorProfile extends StatefulWidget {
  const EditContractorProfile({super.key});

  @override
  State<EditContractorProfile> createState() => _EditContractorProfileState();
}

class _EditContractorProfileState extends State<EditContractorProfile> {
  // Controllers for text fields
  final TextEditingController _fullNameController = TextEditingController(text: 'John Doe');
  final TextEditingController _dobController = TextEditingController(text: '12/12/1980');
  final TextEditingController _genderController = TextEditingController(text: 'Male');
  final TextEditingController _phoneController = TextEditingController(text: '+1 234 567 8901');
  final TextEditingController _emailController = TextEditingController(text: 'johndoe@example.com');
  final TextEditingController _addressController = TextEditingController(text: '123 Main St, Springfield');
  final TextEditingController _companyNameController = TextEditingController(text: 'Doe Constructions');
  final TextEditingController _roleController = TextEditingController(text: 'Senior Contractor');
  final TextEditingController _experienceController = TextEditingController(text: '15 Years');
  final TextEditingController _expertiseController = TextEditingController(text: 'Carpentry, Electrical Work');

  // Save handler
  void _saveProfile() {
    // Collect updated values
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
    };

    // Print updated values (can replace this with API call)
    print('Updated Profile: $updatedProfile');

    // Navigate back to the profile page
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
              _buildTextField('Full Name', _fullNameController),
              _buildTextField('Date of Birth', _dobController),
              _buildTextField('Gender', _genderController),
              _buildTextField('Phone Number', _phoneController),
              _buildTextField('Email Address', _emailController),
              _buildTextField('Address', _addressController),
              const SizedBox(height: 20),
              const Text(
                'Professional Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildTextField('Company Name', _companyNameController),
              _buildTextField('Role/Position', _roleController),
              _buildTextField('Experience', _experienceController),
              _buildTextField('Expertise', _expertiseController),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfile,
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
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
