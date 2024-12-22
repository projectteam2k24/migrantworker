import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class EditWorkerProfile extends StatefulWidget {
  const EditWorkerProfile({super.key});

  @override
  State<EditWorkerProfile> createState() => _EditWorkerProfileState();
}

class _EditWorkerProfileState extends State<EditWorkerProfile> {
  // Controllers for text fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emergencyContactNumber = TextEditingController();
  final TextEditingController _durationOfStay = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _expertiseController = TextEditingController();

  // Image file for the profile picture
  File? _profileImage;
  String? _profileImageUrl;

  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadWorkerData();
  }

  // Load worker data from Firestore
  Future<void> _loadWorkerData() async {
  setState(() => _isLoading = true);
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        setState(() {
          _fullNameController.text = data['name']?.toString() ?? '';
          _dobController.text = data['dob']?.toString() ?? '';
          _genderController.text = data['gender']?.toString() ?? '';
          _phoneController.text = data['phone']?.toString() ?? '';
          _emailController.text = data['email']?.toString() ?? '';
          _addressController.text = data['address']?.toString() ?? '';
          _experienceController.text = data['experience']?.toString() ?? '';
          _expertiseController.text = data['skill']?.toString() ?? '';
          _emergencyContactNumber.text =
              data['emergencyContact']?.toString() ?? '';
          _durationOfStay.text = data['duration']?.toString() ?? '';
          _profileImageUrl = data['profilePic'];
        });
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error loading profile: $e')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}


  // Upload image to Cloudinary
  Future<String?> _uploadImageToCloudinary(File imageFile) async {
    final cloudinary = Cloudinary.signedConfig(
      apiKey: '714694759259219',
      apiSecret: '-yv1E3csFWNunS7jYdQn1eQatz4',
      cloudName: 'diskdblly',
    );

    try {
      final response = await cloudinary.upload(
        file: imageFile.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'worker/profile',
      );

      if (response.isSuccessful) {
        return response.secureUrl;
      } else {
        print('Failed to upload image: ${response.error}');
      }
    } catch (e) {
      print('Error uploading image to Cloudinary: $e');
    }

    return null;
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
  try {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      // User canceled the picker
      return;
    }
    await _cropImage(pickedFile.path);
  } catch (e) {
    print('Error picking image: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error picking image: $e')),
    );
  }
}


  // Crop the selected image
  Future<void> _cropImage(String imagePath) async {
  try {
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
    if (croppedFile == null) {
      // User canceled cropping
      return;
    }
    setState(() {
      _profileImage = File(croppedFile.path);
    });
  } catch (e) {
    print('Error cropping image: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error cropping image: $e')),
    );
  }
}

  // Save updated profile data
  Future<void> _saveProfile() async {
    if (_fullNameController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Phone Number are required')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        if (_profileImage != null) {
          final uploadedImageUrl = await _uploadImageToCloudinary(_profileImage!);
          if (uploadedImageUrl != null) {
            _profileImageUrl = uploadedImageUrl;
          }
        }

        final updatedProfile = {
          'name': _fullNameController.text,
          'dob': _dobController.text,
          'gender': _genderController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'address': _addressController.text,
          'experience': _experienceController.text,
          'skill': _expertiseController.text,
          'duration': _durationOfStay.text,
          'emergencyContact': _emergencyContactNumber.text,
          'profilePic': _profileImageUrl,
        };

        await FirebaseFirestore.instance
            .collection('Worker')
            .doc(userId)
            .update(updatedProfile);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
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
            onPressed: _isSaving ? null : _saveProfile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : (_profileImageUrl != null
                                      ? NetworkImage(_profileImageUrl!)
                                      : const AssetImage(
                                              'assets/profile_placeholder.png'))
                                          as ImageProvider,
                              backgroundColor: Colors.grey[300],
                            ),
                            const Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 18,
                                child: Icon(Icons.edit,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDetailsCard('Personal Details', [
                      _buildTextField('Full Name', _fullNameController),
                      _buildTextField('Date of Birth', _dobController),
                      _buildTextField('Gender', _genderController),
                      _buildTextField('Phone Number', _phoneController),
                      _buildTextField('Email Address', _emailController),
                      _buildTextField('Address', _addressController),
                    ]),
                    const SizedBox(height: 20),
                    _buildDetailsCard('Professional Details', [
                      _buildTextField(
                          'Emergency Contact Number', _emergencyContactNumber),
                      _buildTextField('Duration of Stay', _durationOfStay),
                      _buildTextField('Experience', _experienceController),
                      _buildTextField('Expertise', _expertiseController),
                    ]),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDetailsCard(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}
