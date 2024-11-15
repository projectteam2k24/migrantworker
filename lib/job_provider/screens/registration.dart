import 'package:flutter/material.dart';

class RegisterJobProvider extends StatefulWidget {
  const RegisterJobProvider({super.key});

  @override
  State<RegisterJobProvider> createState() => _RegisterJobProviderState();
}

class _RegisterJobProviderState extends State<RegisterJobProvider> {
  final _formKey = GlobalKey<FormState>(); // Key to manage the form state
  TextEditingController FullNameController = TextEditingController();
  TextEditingController CompanyController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController EmailController = TextEditingController();
  TextEditingController AddressController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
   String UserType = 'Personal';

  bool ShowPass = true;

  // Sign-up handler that checks if the form is valid before printing the email
  void RegisterJobProviderHandler() {
    if (_formKey.currentState?.validate() ?? false) {
      print('Email: ${EmailController.text}');
      print(UserType);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const RegisterJobProvider();
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
    CompanyController.dispose();
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey, // Link the form to the key
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Job Provider Registration',
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
                    'Personal Information',
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
                      controller: FullNameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_2_outlined),
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                          return 'Name should contain only letters';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      controller: PhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      controller: EmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email Address',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      controller: AddressController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.home),
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black, // Border color
                          width: 1.0, // Thickness of the border
                        ),
                        borderRadius:
                            BorderRadius.circular(8.0), // Rounded corners
                        color: Colors.white, // Background color
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: UserType,
                          items: <String>['Company', 'Personal']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Icon(
                                    value == 'Company'
                                        ? Icons.business
                                        : Icons.person,
                                    color: Colors.black, // Icon color
                                  ),
                                  SizedBox(
                                      width: 10), // Space between icon and text
                                  Text(
                                    value,
                                    style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold, // Makes text bold
                                      fontSize:
                                          16.0,
                                          color: Colors.black // Optional: Adjusts font size
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              UserType = newValue!;
                            });
                          },
                          isExpanded: true, // Makes the dropdown fill the width
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold, // Bold text for selected value
                            fontSize: 16.0, // Optional: Adjusts font size
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      controller: PasswordController,
                      obscureText: ShowPass,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.verified_user_outlined),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              ShowPass = !ShowPass;
                            });
                          },
                          icon: Icon(ShowPass
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        border: const OutlineInputBorder(),
                        labelStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: RegisterJobProviderHandler,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 60),
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
            ),
          ),
        ),
      ),
    );
  }
}
