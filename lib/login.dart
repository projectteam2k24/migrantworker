import 'package:flutter/material.dart';
import 'package:migrantworker/selectuser.dart';
import 'package:migrantworker/contractor/screens/homepage.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>(); // Key to manage the form state
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showPass = true;

  void logInHandler() {
    if (_formKey.currentState?.validate() ?? false) {
      print('Email: ${emailController.text}');
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const ContractorHome();
        },
      ));
    } else {
      print('Form is invalid');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0), // Match registration background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.08),
                  Center(
                    child: ClipOval(
                      child: Image.asset(
                        'assets/logo.png',
                        width: screenWidth * 0.4,
                        height: screenWidth * 0.4,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Migrant Connect',
                    style: TextStyle(
                      fontSize: screenWidth * 0.065,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFB7913E),
                      fontFamily: 'Times New Roman',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.1),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_2_outlined,
                            color: Color(0xFFB7913E)),
                        labelText: 'Email/Mobile',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02),
                          borderSide:
                              const BorderSide(color: Color(0xFFB7913E)),
                        ),
                        labelStyle: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFB7913E),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email or mobile number';
                        } else if (RegExp(
                                r"^[a-zA-Z0-9]+@([a-zA-Z0-9]+\.)+[a-zA-Z]{2,}$")
                            .hasMatch(value)) {
                          return null; // Valid email
                        } else if (RegExp(r"^\d{10}$").hasMatch(value)) {
                          return null; // Valid mobile number
                        }
                        return 'Please enter a valid email or 10-digit mobile number';
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: showPass,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Color(0xFFB7913E)),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              showPass = !showPass;
                            });
                          },
                          icon: Icon(
                              showPass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color(0xFFB7913E)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02),
                          borderSide:
                              const BorderSide(color: Color(0xFFB7913E)),
                        ),
                        labelStyle: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFB7913E),
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
                  SizedBox(height: screenHeight * 0.02),
                  GestureDetector(
                    onTap: () {
                      // Add your "Forgot Password" navigation or logic here
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  ElevatedButton(
                    onPressed: logInHandler,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFB7913E), // Match button color
                      minimumSize: Size(screenWidth * 0.5, screenHeight * 0.06),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const SelectUser();
                            },
                          ));
                        },
                        child: Text(
                          'Register Now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: screenWidth * 0.045,
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
