import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:migrantworker/job_provider/screens/homepage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:migrantworker/job_provider/services/job_provider_firebase_auth_service.dart';

class RegisterJobProvider extends StatefulWidget {
  const RegisterJobProvider({super.key});

  @override
  State<RegisterJobProvider> createState() => _RegisterJobProviderState();
}

class _RegisterJobProviderState extends State<RegisterJobProvider> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController FullNameController = TextEditingController();
  final TextEditingController CompanyController = TextEditingController();
  final TextEditingController PhoneController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController AddressController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();
  String UserType = 'Personal';

  bool ShowPass = true;
  File? _profileImage;
  String? imageUrl;

  final cloudinary = Cloudinary.signedConfig(
    apiKey: '714694759259219',
    apiSecret: '-yv1E3csFWNunS7jYdQn1eQatz4',
    cloudName: 'diskdblly',
  );

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 200,
      maxWidth: 200,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      // Upload image after picking
      imageUrl = await _uploadImage(_profileImage!);
      if (imageUrl != null) {
        print('Image uploaded successfully: $imageUrl');
        // You can store the imageUrl if needed
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload profile picture')),
        );
      }
    }
  }

  // Function to upload image to Cloudinary
  Future<String?> _uploadImage(File image) async {
    try {
      final response = await cloudinary.upload(
        file: image.path,
        fileBytes: image.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        folder: 'job_provider/profiles', // Optional folder name
      );

      if (response.isSuccessful) {
        return response.secureUrl;
      } else {
        throw Exception('Failed to upload image: ${response.error}');
      }
    } catch (e) {
      print('Cloudinary upload error: $e');
      return null;
    }
  }

  Future<void> RegisterJobProviderHandler() async {
    if (_formKey.currentState?.validate() ?? false) {
      Future<bool> res = JobProviderFirebaseAuthService().jobProviderReg(
          name: FullNameController.text,
          phone: PhoneController.text,
          email: EmailController.text,
          address: AddressController.text,
          userType: UserType,
          password: PasswordController.text,
          context: context,
          profile: imageUrl);
      if (await res) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const JobProviderHome();
            },
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Registration failed. Email already in use')));
      }
    } else {
      print('Form is invalid');
    }
  }

  @override
  void dispose() {
    FullNameController.dispose();
    CompanyController.dispose();
    PhoneController.dispose();
    EmailController.dispose();
    AddressController.dispose();
    PasswordController.dispose();
    super.dispose();
  }

  Widget _buildProfilePicture() {
    return Stack(
      children: [
        // Profile Picture
        GestureDetector(
          onTap: _pickImage, // Trigger image picker when tapped
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                _profileImage != null ? FileImage(_profileImage!) : null,
            child: _profileImage == null
                ? const Icon(Icons.camera_alt, color: Colors.green, size: 40)
                : null,
          ),
        ),

        // Edit Icon
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage, // Trigger image picker when tapped
            child: const CircleAvatar(
              radius: 15,
              backgroundColor: Colors.green,
              child: Icon(
                Icons.edit,
                size: 15,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Job Provider Registration',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildProfilePicture(),
                        const SizedBox(height: 5),
                        buildTextField(
                          controller: FullNameController,
                          label: 'Full Name',
                          icon: Icons.person_2_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                .hasMatch(value)) {
                              return 'Name should contain only letters';
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          controller: PhoneController,
                          label: 'Phone Number',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (!RegExp(r'^[0-9]{10}$')
                                .hasMatch(value)) {
                              return 'Phone number must be 10 digits';
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          controller: EmailController,
                          label: 'Email Address',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(
                                    r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          controller: AddressController,
                          label: 'Address',
                          icon: Icons.home,
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                        ),
                        buildDropdownField(),
                        buildPasswordField(),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: ElevatedButton(
                            onPressed: RegisterJobProviderHandler,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(200, 50),
                              backgroundColor: Colors.green[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.green),
            labelText: label,
            labelStyle: TextStyle(fontSize: 18, color: Colors.green[800]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: validator,
        ),
      ),
    );
  }

  Widget buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: UserType,
            dropdownColor: Colors.white,
            items: ['Company', 'Personal'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    Icon(
                      value == 'Company' ? Icons.business : Icons.person,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 10),
                    Text(value, style: TextStyle(color: Colors.green[800])),
                  ],
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                UserType = newValue!;
              });
            },
            isExpanded: true,
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: TextFormField(
          controller: PasswordController,
          obscureText: ShowPass,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.green),
            labelText: 'Password',
            labelStyle: const TextStyle(fontSize: 18, color: Colors.green),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  ShowPass = !ShowPass;
                });
              },
              icon: Icon(
                ShowPass ? Icons.visibility : Icons.visibility_off,
              ),
              color: Colors.lightGreen,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
        ),
      ),
    );
  }
}
