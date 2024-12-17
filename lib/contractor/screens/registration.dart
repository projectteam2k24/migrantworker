import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:migrantworker/contractor/screens/homepage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:migrantworker/contractor/services/contractor_firebase_auth_service.dart';

class RegisterContractor extends StatefulWidget {
  const RegisterContractor({super.key});

  @override
  _RegisterContractorState createState() => _RegisterContractorState();
}

class _RegisterContractorState extends State<RegisterContractor> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController FullNameController = TextEditingController();
  final TextEditingController DOBController = TextEditingController();
  final TextEditingController GenderController = TextEditingController();
  final TextEditingController PhoneController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();

  bool ShowPass = false;
  File? _profileImage;
  String? profileUrl;

  final Cloudinary _cloudinary = Cloudinary.signedConfig(
    apiKey: '714694759259219',
    apiSecret: '-yv1E3csFWNunS7jYdQn1eQatz4',
    cloudName: 'diskdblly',
  );

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery, // Use ImageSource.camera for camera option
      maxHeight: 200,
      maxWidth: 200,
    );
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Helper to wrap input fields in styled containers
  Widget _buildInputContainer(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  // Profile Picture Widget
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

  // Registration Button Handler
  Future<void> RegisterContractorHandler() async {
    if (_formKey.currentState!.validate()) {
      if (_profileImage != null) {
        final response = await _cloudinary.upload(
          file: _profileImage!.path,
          fileBytes: File(_profileImage!.path).readAsBytesSync(),
          resourceType: CloudinaryResourceType.image,
          folder: 'contractor_profiles', // Optional folder
        );
        if (response.isSuccessful) {
          profileUrl = response.secureUrl!;
        }
      }
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterContractor1(
              name: FullNameController.text,
              dob: DOBController.text,
              gender: GenderController.text,
              phone: PhoneController.text,
              email: EmailController.text,
              password: PasswordController.text,
              profilePic: profileUrl,
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Form Container
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Contractor Registration',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontFamily: 'Times New Roman',
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          _buildProfilePicture(),

                          // Full Name Field
                          _buildInputContainer(
                            TextFormField(
                              controller: FullNameController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person_2_outlined,
                                    color: Colors.green),
                                labelText: 'Full Name',
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                ),
                                border: InputBorder.none,
                              ),
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
                          ),

                          // Date of Birth Field
                          _buildInputContainer(
                            TextFormField(
                              controller: DOBController,
                              readOnly: true, // Prevent manual typing
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.calendar_today,
                                    color: Colors.green),
                                labelText: 'Date of Birth',
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                ),
                                border: InputBorder.none,
                              ),
                              onTap: () async {
                                // Open date picker on field tap
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2000), // Default date
                                  firstDate: DateTime(1900), // Start date
                                  lastDate: DateTime.now(), // End date
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: Colors
                                              .green, // Header background color
                                          onPrimary:
                                              Colors.white, // Header text color
                                          onSurface:
                                              Colors.green, // Body text color
                                        ),
                                        textButtonTheme: TextButtonThemeData(
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors
                                                .green, // Button text color
                                          ),
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedDate != null) {
                                  setState(() {
                                    DOBController.text =
                                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your date of birth';
                                }
                                return null;
                              },
                            ),
                          ),

                          // Gender Field
                          _buildInputContainer(
                            TextFormField(
                              controller: GenderController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person_2_outlined,
                                    color: Colors.green),
                                labelText: 'Gender',
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                ),
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your gender';
                                }
                                return null;
                              },
                            ),
                          ),

                          // Phone Number Field
                          _buildInputContainer(
                            TextFormField(
                              controller: PhoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                prefixIcon:
                                    Icon(Icons.phone, color: Colors.green),
                                labelText: 'Phone Number',
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                ),
                                border: InputBorder.none,
                              ),
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
                          ),
                          // Email Field
                          _buildInputContainer(
                            TextFormField(
                              controller: EmailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email_outlined,
                                    color: Colors.green),
                                labelText: 'Email Address',
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                ),
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email address';
                                } else if (!RegExp(
                                        r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                          ),
                          // Password Field
                          _buildInputContainer(
                            TextFormField(
                              controller: PasswordController,
                              obscureText: ShowPass,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline,
                                    color: Colors.green),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      ShowPass = !ShowPass;
                                    });
                                  },
                                  icon: Icon(
                                    ShowPass
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.lightGreen,
                                  ),
                                ),
                                labelStyle: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                ),
                                border: InputBorder.none,
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
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Next Button
                  ElevatedButton(
                    onPressed: RegisterContractorHandler,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 60),
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterContractor1 extends StatefulWidget {
  const RegisterContractor1({
    super.key,
    required this.name,
    required this.dob,
    required this.gender,
    required this.phone,
    required this.password,
    required this.email,
    this.profilePic,
  });
  final String name;
  final String dob;
  final String gender;
  final String phone;
  final String email;
  final String password;
  final String? profilePic;

  @override
  State<RegisterContractor1> createState() => _RegisterContractor1State();
}

class _RegisterContractor1State extends State<RegisterContractor1> {
  final _formKey = GlobalKey<FormState>(); // Key to manage the form state
  TextEditingController CompanyController = TextEditingController();
  TextEditingController RoleController = TextEditingController();
  TextEditingController ExcperienceController = TextEditingController();
  TextEditingController ExpertiseController = TextEditingController();

  bool ShowPass = true;

  final Cloudinary _cloudinary = Cloudinary.signedConfig(
    apiKey: '714694759259219',
    apiSecret: '-yv1E3csFWNunS7jYdQn1eQatz4',
    cloudName: 'diskdblly',
  );

  Future<String?> uploadFileToCloudinary(
      String filePath, String folderName) async {
    try {
      final response = await _cloudinary.upload(
        file: filePath,
        resourceType: CloudinaryResourceType.auto,
        folder: folderName, // Dynamic folder name
      );

      if (response.isSuccessful) {
        return response.secureUrl; // Return the uploaded file's URL
      } else {
        print('Cloudinary upload failed: ${response.error}');
      }
    } catch (e) {
      print('Exception during upload: $e');
    }
    return null;
  }

  // previous handler that helps to go back to the previous page
  void PrevHandler() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const RegisterContractor();
      },
    )); // You can add further sign-up logic here, like calling an API
  }

  // Sign-up handler that checks if the form is valid before printing the email
  void RegisterContractorHandler() {
    if (_formKey.currentState?.validate() ?? false) {
      ContractorFirebaseAuthService().contractorReg(
          name: widget.name,
          dob: widget.dob,
          gender: widget.gender,
          phone: widget.phone,
          email: widget.email,
          password: widget.password,
          profile: widget.profilePic,
          companyName: CompanyController.text,
          role: RoleController.text,
          skill: ExpertiseController.text,
          experience: ExcperienceController.text,
          govtID: govtIdFile,
          companyCertificate: CompRegFile,
          AddressProof: AddressProofFile,
          context: context);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const ContractorHome();
        },
      )); // You can add further sign-up logic here, like calling an API
    } else {
      print('Form is invalid');
    }
  }

  //
  String? govtIdFile;
  String? CompRegFile;
  String? AddressProofFile;

  // Function to handle file selection
  Future<void> selectGovtIdFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      final uploadedUrl = await uploadFileToCloudinary(
          result.files.single.path!, "contractor_docs/govt_id");
      if (uploadedUrl != null) {
        setState(() {
          govtIdFile = uploadedUrl; // Save the Cloudinary URL
        });
      }
    }
  }

  // Function to handle file selection
  Future<void> selectCompRegFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      final uploadedUrl = await uploadFileToCloudinary(
          result.files.single.path!, "contractor_docs/company_reg");
      if (uploadedUrl != null) {
        setState(() {
          CompRegFile = uploadedUrl; // Save the Cloudinary URL
        });
      }
    }
  }

  // Function to handle file selection
  Future<void> selectAddressProofFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      final uploadedUrl = await uploadFileToCloudinary(
          result.files.single.path!, "contractor_docs/address_proof");
      if (uploadedUrl != null) {
        setState(() {
          AddressProofFile = uploadedUrl; // Save the Cloudinary URL
        });
      }
    }
  }

  @override
  void dispose() {
    // Dispose the controllers to prevent memory leaks
    CompanyController.dispose();
    RoleController.dispose();
    ExcperienceController.dispose();
    ExpertiseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Professional Information Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Professional Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontFamily: 'Times New Roman',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        buildTextField(
                          controller: CompanyController,
                          label: 'Company Name',
                          icon: Icons.business_center,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Company Name is required';
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          controller: RoleController,
                          label: 'Role / Position',
                          icon: Icons.work_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Role/Position is required';
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          controller: ExcperienceController,
                          label: 'Experience',
                          icon: Icons.timeline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Experience is required';
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          controller: ExpertiseController,
                          label: 'Expertise/Specialization',
                          icon: Icons.star_border,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Document Upload Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Document Upload',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontFamily: 'Times New Roman',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        buildUploadRow(
                          title: "Government issued ID:",
                          onPressed: selectGovtIdFile,
                          isSelected: govtIdFile != null,
                        ),
                        buildUploadRow(
                          title: "Company Reg. Certificate:",
                          onPressed: selectCompRegFile,
                          isSelected: CompRegFile != null,
                        ),
                        buildUploadRow(
                          title: "Proof of address:",
                          onPressed: selectAddressProofFile,
                          isSelected: AddressProofFile != null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Buttons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: PrevHandler,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 40),
                          backgroundColor: Colors.green[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Previous",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: RegisterContractorHandler,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 40),
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
                    ],
                  ),
                ],
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
              blurRadius: 2,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.green),
            labelText: label,
            labelStyle: TextStyle(fontSize: 16, color: Colors.green[800]),
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

  Widget buildUploadRow({
    required String title,
    required VoidCallback onPressed,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(120, 40),
              backgroundColor: Colors.green[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isSelected ? "File Selected" : "Upload File",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
