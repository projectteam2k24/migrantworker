import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudinary/cloudinary.dart'; // Cloudinary package
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For date formatting

class EditContractorProfile extends StatefulWidget {
  const EditContractorProfile({super.key});

  @override
  State<EditContractorProfile> createState() => _EditContractorProfileState();
}

class _EditContractorProfileState extends State<EditContractorProfile> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _expertiseController = TextEditingController();

  String? _profilePictureUrl;
  String? _gender;
  final _formKey = GlobalKey<FormState>();

  final Cloudinary _cloudinary = Cloudinary.signedConfig(
    apiKey: '714694759259219',
    apiSecret: '-yv1E3csFWNunS7jYdQn1eQatz4',
    cloudName: 'diskdblly',
  );

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
            _gender = data['gender'] ?? '';
            _phoneController.text = data['phone'] ?? '';
            _companyNameController.text = data['companyName'] ?? '';
            _roleController.text = data['role'] ?? '';
            _experienceController.text = data['experience'] ?? '';
            _expertiseController.text = data['skill'] ?? '';
            _profilePictureUrl = data['profilePicture'];
          });
        }
      }
    } catch (e) {
      print('Error loading contractor data: $e');
    }
  }

  // Save updated profile data to Firestore
  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final userId = FirebaseAuth.instance.currentUser?.uid;
        if (userId != null) {
          final updatedProfile = {
            'name': _fullNameController.text,
            'dob': _dobController.text,
            'gender': _gender,
            'phone': _phoneController.text,
            'companyName': _companyNameController.text,
            'role': _roleController.text,
            'experience': _experienceController.text,
            'skill': _expertiseController.text,
            'profilePicture': _profilePictureUrl,
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
  }

  // Pick and upload profile picture to Cloudinary
  Future<void> _pickAndUploadProfilePicture() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final response = await _cloudinary.upload(
          file: pickedFile.path,
          resourceType: CloudinaryResourceType.image,
          folder:
              'contracotr_doc/profile_pictures', // Optional folder to organize images in Cloudinary
        );

        if (response.isSuccessful) {
          setState(() {
            _profilePictureUrl = response.secureUrl;
          });
        } else {
          print('Cloudinary upload failed');
        }
      }
    } catch (e) {
      print('Error uploading profile picture: $e');
    }
  }
  
  // Date Picker for DOB
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _profilePictureUrl != null
                            ? NetworkImage(_profilePictureUrl!)
                            : null,
                        backgroundColor: Colors.grey[300],
                        child: _profilePictureUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickAndUploadProfilePicture,
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.green[700],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Personal Details Section
                _buildInfoContainer('Personal Details', [
                  _buildTextField('Full Name', _fullNameController),
                  _buildDateOfBirthField('Date of Birth', _dobController),
                  _buildGenderDropdown('Gender'),
                  _buildPhoneNumberField('Phone Number', _phoneController),
                ]),
                const SizedBox(height: 20),

                // Professional Details Section
                _buildInfoContainer('Professional Details', [
                  _buildTextField('Company Name', _companyNameController),
                  _buildTextField('Role/Position', _roleController),
                  _buildTextField('Experience', _experienceController),
                  _buildTextField('Expertise', _expertiseController),
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
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
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
      child: TextFormField(
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

  // Custom phone number validation field
  Widget _buildPhoneNumberField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your phone number';
          } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
            return 'Phone number must be 10 digits';
          }
          return null;
        },
      ),
    );
  }

  // Dropdown for gender selection
  Widget _buildGenderDropdown(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _gender,
        onChanged: (newValue) {
          setState(() {
            _gender = newValue;
          });
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: ['Male', 'Female', 'Other']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select your gender';
          }
          return null;
        },
      ),
    );
  }

  // Date picker for DOB
  Widget _buildDateOfBirthField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: TextFormField(
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
        ),
      ),
    );
  }
}
