import 'package:flutter/material.dart';
import 'package:migrantworker/contractor/screens/homepage.dart';
import 'package:file_picker/file_picker.dart';

class RegisterContractor extends StatefulWidget {
  const RegisterContractor({super.key});

  @override
  State<RegisterContractor> createState() => _RegisterContractorState();
}

class _RegisterContractorState extends State<RegisterContractor> {
  final _formKey = GlobalKey<FormState>(); // Key to manage the form state
  TextEditingController FullNameController = TextEditingController();
  TextEditingController DOBController = TextEditingController();
  TextEditingController GenderController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController AddressController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();

  bool ShowPass = true;

  // Sign-up handler that checks if the form is valid before printing the email
  void RegisterContractorHandler() {
    if (true) {
      // _formKey.currentState?.validate() ?? false -!!!repalce this condition after test
      print('Email: ${EmailController.text}');
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const RegisterContractor1();
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

                  // Form Container with BoxDecoration
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

// Helper Function for Individual Input Field Styling
  Widget _buildInputContainer(Widget child) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: child,
      ),
    );
  }
}

class RegisterContractor1 extends StatefulWidget {
  const RegisterContractor1({super.key});

  @override
  State<RegisterContractor1> createState() => _RegisterContractor1State();
}

class _RegisterContractor1State extends State<RegisterContractor1> {
  final _formKey = GlobalKey<FormState>(); // Key to manage the form state
  TextEditingController CompanyController = TextEditingController();
  TextEditingController RoleController = TextEditingController();
  TextEditingController ExcperienceController = TextEditingController();
  TextEditingController ExpertiseController = TextEditingController();
  TextEditingController GovtController = TextEditingController();
  TextEditingController CompRegController = TextEditingController();
  TextEditingController AddressProofController = TextEditingController();

  bool ShowPass = true;

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
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        govtIdFile = result.files.single.path;
      });
    }
  }

  // Function to handle file selection
  Future<void> selectCompRegFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        CompRegFile = result.files.single.path;
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
    CompanyController.dispose();
    RoleController.dispose();
    ExcperienceController.dispose();
    ExpertiseController.dispose();
    GovtController.dispose();
    CompRegController.dispose();
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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 20),
                  const Text(
                    'Professional Information',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Times New Roman',
                        decoration: TextDecoration.underline),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      controller: CompanyController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_2_outlined),
                        labelText: 'Company Name',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Company Name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      controller: RoleController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        labelText: 'Role / Position',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Role/Position is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      controller: ExcperienceController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_2_outlined),
                        labelText: 'Experience',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Experience is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      controller: ExpertiseController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: 'Expertise/Specialization',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Document Upload',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Times New Roman',
                        decoration: TextDecoration.underline),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Government issued ID:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: selectGovtIdFile,
                          child: Text(govtIdFile == null
                              ? "Upload File"
                              : "File Selected"),
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
                          "Company Reg. Certificate:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: selectCompRegFile,
                          child: Text(CompRegFile == null
                              ? "Upload File"
                              : "File Selected"),
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
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: selectAddressProofFile,
                          child: Text(AddressProofFile == null
                              ? "Upload File"
                              : "File Selected"),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 55.0),
                        child: ElevatedButton(
                          onPressed: PrevHandler,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 40),
                          ),
                          child: const Text(
                            "Previous",
                            style: TextStyle(
                              fontSize: 23,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ElevatedButton(
                          onPressed:
                              RegisterContractorHandler, // Updated to call RegisterContractorHandler
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 40),
                          ),
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 23,
                            ),
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
}
