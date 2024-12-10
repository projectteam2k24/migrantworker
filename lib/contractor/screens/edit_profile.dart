import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditContractorProfile extends StatefulWidget {
  const EditContractorProfile({super.key});

  @override
  State<EditContractorProfile> createState() => _EditContractorProfileState();
}

class _EditContractorProfileState extends State<EditContractorProfile> {
  // Controllers for text fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _expertiseController = TextEditingController();

  // Dummy Document URLs (for now)
  String? _govIdUrl = "https://dummyurl.com/gov_id";
  String? _companyRegUrl = "https://dummyurl.com/company_reg";
  String? _proofOfAddressUrl = "https://dummyurl.com/proof_of_address";

  @override
  void initState() {
    super.initState();
    _loadContractorData();
  }

  // Load contractor data from Firestore
  Future<void> _loadContractorData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('Contractor')
            .doc(userId)
            .get();

        if (snapshot.exists) {
          final data = snapshot.data()!;
          setState(() {
            _fullNameController.text = data['name'] ?? '';
            _dobController.text = data['dob'] ?? '';
            _genderController.text = data['gender'] ?? '';
            _phoneController.text = data['phone'] ?? '';
            _emailController.text = data['email'] ?? '';
            _addressController.text = data['address'] ?? '';
            _companyNameController.text = data['companyName'] ?? '';
            _roleController.text = data['role'] ?? '';
            _experienceController.text = data['experience'] ?? '';
            _expertiseController.text = data['skill'] ?? '';
            _govIdUrl = data['govIdUrl'] ?? _govIdUrl;
            _companyRegUrl = data['companyRegUrl'] ?? _companyRegUrl;
            _proofOfAddressUrl = data['proofOfAddressUrl'] ?? _proofOfAddressUrl;
          });
        }
      }
    } catch (e) {
      print('Error loading contractor data: $e');
    }
  }

  // Save updated profile data
  Future<void> _saveProfile() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final updatedProfile = {
          'name': _fullNameController.text,
          'dob': _dobController.text,
          'gender': _genderController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'address': _addressController.text,
          'companyName': _companyNameController.text,
          'role': _roleController.text,
          'experience': _experienceController.text,
          'skill': _expertiseController.text,
          'govIdUrl': _govIdUrl,
          'companyRegUrl': _companyRegUrl,
          'proofOfAddressUrl': _proofOfAddressUrl,
        };

        await FirebaseFirestore.instance
            .collection('Contractor')
            .doc(userId)
            .update(updatedProfile);

        Navigator.pop(context);
      }
    } catch (e) {
      print('Error saving profile: $e');
    }
  }

  // Document Item display function
  Widget _buildDocumentItem(String label, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Personal Details Card
              _buildInfoContainer('Personal Details', [
                _buildTextField('Full Name', _fullNameController),
                _buildTextField('Date of Birth', _dobController),
                _buildTextField('Gender', _genderController),
                _buildTextField('Phone Number', _phoneController),
                _buildTextField('Email Address', _emailController),
                _buildTextField('Address', _addressController),
              ]),
              const SizedBox(height: 20),

              // Professional Details Card
              _buildInfoContainer('Professional Details', [
                _buildTextField('Company Name', _companyNameController),
                _buildTextField('Role/Position', _roleController),
                _buildTextField('Experience', _experienceController),
                _buildTextField('Expertise', _expertiseController),
              ]),
              const SizedBox(height: 20),

              // Documents Section
              _buildInfoContainer('Documents', [
                _buildDocumentItem('Government Issued ID', _govIdUrl != null ? 'Uploaded' : 'Not Uploaded'),
                _buildDocumentItem('Company Reg. Certificate', _companyRegUrl != null ? 'Uploaded' : 'Not Uploaded'),
                _buildDocumentItem('Proof of Address', _proofOfAddressUrl != null ? 'Uploaded' : 'Not Uploaded'),
              ]),
              const SizedBox(height: 30),

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
                  child: const Text('Save Changes', style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoContainer(String title, List<Widget> children) {
    return Card(
      elevation: 8,
      shadowColor: Colors.green.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: const Color.fromARGB(228, 247, 246, 246),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
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
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
