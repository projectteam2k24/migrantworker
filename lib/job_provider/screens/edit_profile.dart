import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:migrantworker/job_provider/screens/homepage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController userTypeController = TextEditingController();

  File? _profileImage;
  String _profileImageUrl = '';
  bool isLoading = true;
  bool isUploading = false;
  String userType = '';

  final cloudinary = Cloudinary.signedConfig(
    apiKey: '714694759259219',
    apiSecret: '-yv1E3csFWNunS7jYdQn1eQatz4',
    cloudName: 'diskdblly',
  );

  @override
  void initState() {
    super.initState();
    _fetchProfileDetails();
  }

  Future<void> _fetchProfileDetails() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('Job Provider')
            .doc(userId)
            .get();

        if (snapshot.exists) {
          final data = snapshot.data();
          setState(() {
            fullNameController.text = data?['name'] ?? '';
            phoneController.text = data?['phone'] ?? '';
            emailController.text = data?['email'] ?? '';
            addressController.text = data?['address'] ?? '';
            userType = data?['userType'] ?? '';
            _profileImageUrl = data?['profile'] ?? '';
            isLoading = false;
          });
        }
      } else {
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImageToCloudinary(File image) async {
    try {
      final response = await cloudinary.upload(
        file: image.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'job_provider/profiles',
      );

      if (response.isSuccessful) {
        return response.secureUrl;
      } else {
        print('Cloudinary upload error: ${response.error}');
        return null;
      }
    } catch (e) {
      print('Error uploading image to Cloudinary: $e');
      return null;
    }
  }

  Future<void> _saveProfileDetails() async {
    setState(() {
      isUploading = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (_profileImage != null) {
        final imageUrl = await _uploadImageToCloudinary(_profileImage!);
        if (imageUrl != null) {
          _profileImageUrl = imageUrl;
        } else {
          throw Exception('Failed to upload profile image');
        }
      }

      if (userId != null) {
        await FirebaseFirestore.instance.collection('Job Provider').doc(userId).set({
          'name': fullNameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
          'address': addressController.text,
          'userType': userType,
          'profile': _profileImageUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const JobProviderHome()),
        );
      } else {
        print('User is not logged in');
      }
    } catch (e) {
      print('Error saving profile details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save profile details')),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: isUploading ? null : _saveProfileDetails,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _profileImageUrl.isNotEmpty
                              ? NetworkImage(_profileImageUrl)
                              : const AssetImage('assets/profile_placeholder.png')
                                  as ImageProvider,
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: _pickImage,
                          iconSize: 30,
                          color: Colors.green[700],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildEditableProfileItem('Full Name', fullNameController),
                  _buildEditableProfileItem('Phone Number', phoneController),
                  _buildEditableProfileItem('Email Address', emailController),
                  _buildEditableProfileItem('Address', addressController),
                  _buildUserTypeDropdown(),
                ],
              ),
            ),
          ),
          if (isUploading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
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
          Text(label),
          const SizedBox(height: 8),
          TextField(controller: controller),
        ],
      ),
    );
  }

  Widget _buildUserTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: userType.isNotEmpty ? userType : null,
      items: ['Personal', 'Company'].map((type) {
        return DropdownMenuItem(value: type, child: Text(type));
      }).toList(),
      onChanged: (value) {
        setState(() {
          userType = value!;
        });
      },
    );
  }
}
