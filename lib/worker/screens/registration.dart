import 'dart:core';
import 'package:flutter/material.dart';
import 'package:migrantworker/worker/screens/homepage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:migrantworker/worker/services/worker_firebase_auth_service.dart';
import 'package:cloudinary/cloudinary.dart';

class RegisterWorker extends StatefulWidget {
  const RegisterWorker({super.key});

  @override
  State<RegisterWorker> createState() => _RegisterWorkerState();
}

class _RegisterWorkerState extends State<RegisterWorker> {
  final _formKey = GlobalKey<FormState>(); // Key to manage the form state
  TextEditingController FullNameController = TextEditingController();
  TextEditingController DOBController = TextEditingController();
  TextEditingController GenderController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController AddressController = TextEditingController();
  TextEditingController EmergencyPhoneController = TextEditingController();
  TextEditingController StayController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();

  bool ShowPass = true;
  File? _profileImage;

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

  // Sign-up handler that checks if the form is valid before printing the email

  void RegisterWorkerHandler() {
    if (_formKey.currentState?.validate() ?? false) {
      print('Email: ${EmailController.text}');
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return RegisterWorker1(
            name: FullNameController.text,
            profilepic: _profileImage,
            dob: DOBController.text,
            gender: GenderController.text,
            phone: PhoneController.text,
            email: EmailController.text,
            address: AddressController.text,
            emergencyContact: EmergencyPhoneController.text,
            duration: int.parse(StayController.text),
            password: PasswordController.text,
          );
        },
      )); // You can add further sign-up logic here, like calling an API
    } else {
      print('Form is invalid');
    }
  }

  @override
  void dispose() {
    // Dispose the controllers to prevent memory leaks
    FullNameController.dispose();
    DOBController.dispose();
    GenderController.dispose();
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Container(
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
                        children: [
                          const Text(
                            'Worker Registration',
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
                          Padding(
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
                                controller: DOBController,
                                decoration: const InputDecoration(
                                  labelText: 'Date of Birth',
                                  labelStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
                                  ),
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.calendar_today,
                                    color: Colors.green,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your date of birth';
                                  }
                                  return null;
                                },
                                onTap: () async {
                                  // Prevent the keyboard from showing
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  // Show date picker
                                  DateTime? selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: Colors
                                                .green, // Header background color
                                            onPrimary: Colors
                                                .white, // Header text color
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

                                  // Format the date and set it to the controller
                                  DOBController.text =
                                      "${selectedDate!.toLocal()}"
                                          .split(' ')[0]; // YYYY-MM-DD
                                                                },
                                readOnly:
                                    true, // To prevent typing in the text field
                              ),
                            ),
                          ),
                          buildTextField(
                            controller: GenderController,
                            label: 'Gender',
                            icon: Icons.person_2_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your gender';
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
                          buildTextField(
                            controller: EmergencyPhoneController,
                            label: 'Emergency Contact Number',
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
                            controller: StayController,
                            label:
                                'Duration of Stay at Current Location (Months)',
                            icon: Icons.location_city,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid duration';
                              }
                              return null;
                            },
                          ),
                          buildPasswordField(),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: ElevatedButton(
                              onPressed: RegisterWorkerHandler,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 50),
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
                          ),
                        ],
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

  Widget buildPasswordField() {
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

class RegisterWorker1 extends StatefulWidget {
  const RegisterWorker1(
      {super.key,
      required this.name,
      required this.profilepic,
      required this.dob,
      required this.gender,
      required this.phone,
      required this.email,
      required this.address,
      required this.emergencyContact,
      required this.duration,
      required this.password});
  final String name;
  final File? profilepic;
  final String dob;
  final String gender;
  final String phone;
  final String email;
  final String address;
  final String emergencyContact;
  final int duration;
  final String password;

  @override
  State<RegisterWorker1> createState() => _RegisterWorker1State();
}

class _RegisterWorker1State extends State<RegisterWorker1> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController ExpertiseController =
      TextEditingController(); // Key to manage the form state
  TextEditingController ExcperienceController = TextEditingController();
  TextEditingController SalaryController = TextEditingController();
  TextEditingController LanguageController = TextEditingController();
  TextEditingController GovtController = TextEditingController();

  bool ShowPass = true;

  final cloudinary = Cloudinary.signedConfig(
    apiKey: '714694759259219',
    apiSecret: '-yv1E3csFWNunS7jYdQn1eQatz4',
    cloudName: 'diskdblly',
  );

  // previous handler that helps to go back to the previous page
  void PrevHandler() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const RegisterWorker();
      },
    )); // You can add further sign-up logic here, like calling an API
  }

  // Sign-up handler that checks if the form is valid before printing the email
// Updated RegisterWorkerHandler to handle file uploads
  Future<void> RegisterWorkerHandler() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Upload files to Cloudinary
        String? profileUrl;
        String? govtIdUrl;
        String? addressProofUrl;

        // Upload Profile Picture
        if (widget.profilepic != null) {
          final response = await cloudinary.upload(
            file: widget.profilepic!.path,
            resourceType: CloudinaryResourceType.image,
            folder: 'worker/profile',
          );
          profileUrl = response.secureUrl;
        }

        // Upload Government ID
        if (govtIdFile != null) {
          final response = await cloudinary.upload(
              file: govtIdFile!,
              resourceType: CloudinaryResourceType.image,
              folder: 'worker/govtIdFiles');
          govtIdUrl = response.secureUrl;
        }

        // Upload Address Proof
        if (AddressProofFile != null) {
          final response = await cloudinary.upload(
              file: AddressProofFile!,
              resourceType: CloudinaryResourceType.image,
              folder: 'worker/addressProofFiles');
          addressProofUrl = response.secureUrl;
        }

        // Call the workerReg method with the uploaded URLs
        Future<bool> res = WorkerAuthService().workerReg(
          name: widget.name,
          dob: widget.dob,
          gender: widget.gender,
          phone: widget.phone,
          email: widget.email,
          address: widget.address,
          emergencyContact: widget.emergencyContact,
          duration: widget.duration,
          password: widget.password,
          skill: ExpertiseController.text,
          salary: SalaryController.text,
          languages: LanguageController.text,
          govtID: govtIdUrl,
          AddressProof: addressProofUrl,
          profile: profileUrl,
          context: context,
        );

        if (await res) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WorkerHome(),
              ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Registration failed. Email already in use.')));
        }
      } catch (e) {
        print('Error during file upload: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload files.')),
        );
      }
    } else {
      print('Form is invalid');
    }
  }

  String? govtIdFile;
  String? AddressProofFile;

  // Function to handle file selection
  Future<void> selectGovtIdFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        govtIdFile = result.files.single.path;
      });
    }
  }

  // Function to handle file selection
  Future<void> selectAddressProofFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        AddressProofFile = result.files.single.path;
      });
    }
  }

  @override
  void dispose() {
    // Dispose the controllers to prevent memory leaks
    ExcperienceController.dispose();
    ExpertiseController.dispose();
    GovtController.dispose();
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
              key: _formKey, // Link the form to the key
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
                          controller: ExpertiseController,
                          label: 'Skill/Expertise',
                          icon: Icons.calendar_today,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Skill/Expertise is required';
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          controller: ExcperienceController,
                          label: 'Work Experience',
                          icon: Icons.person_2_outlined,
                          validator: null, // Optional validation
                        ),
                        buildTextField(
                          controller: SalaryController,
                          label: 'Expected Salary',
                          icon: Icons.attach_money,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter a valid amount";
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          controller: LanguageController,
                          label: 'Language Spoken',
                          icon: Icons.language,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter a valid Language";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
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
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Government issued ID: ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: selectGovtIdFile,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(120, 40),
                                  backgroundColor: Colors.green[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  govtIdFile == null
                                      ? "Upload File"
                                      : "File Selected",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Proof of address :",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: selectAddressProofFile,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(120, 40),
                                  backgroundColor: Colors.green[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  AddressProofFile == null
                                      ? "Upload File"
                                      : "File Selected",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Buttons Row (Previous and Register)
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
                        onPressed:
                            RegisterWorkerHandler, // Updated to call RegisterWorkerHandler
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
    TextInputType keyboardType = TextInputType.text,
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
              color: Colors.green.withOpacity(0.04),
              blurRadius: 2,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.green),
            labelText: label,
            labelStyle: TextStyle(fontSize: 20, color: Colors.green[800]),
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
}
