import 'package:flutter/material.dart';
import 'package:migrantworker/worker/screens/selectuser.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>(); // Key to manage the form state
  TextEditingController EmailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();

  bool ShowPass = true;

  // Sign-up handler that checks if the form is valid before printing the email
  void LogInHandler() {
    if (_formKey.currentState?.validate() ?? false) {
      print('Email: ${EmailController.text}');
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return LogIn();
        },
      )); // You can add further sign-up logic here, like calling an API
    } else {
      print('Form is invalid');
    }
  }

  @override
  void dispose() {
    // Dispose the controllers to prevent memory leaks
    EmailController.dispose();
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
                  Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(
                      child: ClipOval(
                        child: Image(
                          image: AssetImage('assets/logo.png'),
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Migrant Connect',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(183, 145, 62, 10),
                      fontFamily: 'Times New Roman',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 150.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      controller: EmailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person_2_outlined),
                        labelText: 'Email/Mobile',
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
                                r"^[a-zA-Z0-9]+@([a-zA-Z0-9]+\.)+[a-zA-Z]{2,}$")
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 23.0, left: 20.0, right: 20.0),
                    child: TextFormField(
                      controller: PasswordController,
                      obscureText: ShowPass,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.verified_user_outlined),
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
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(
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
                    child: GestureDetector(
                      onTap: () {
                        // Add your "Forgot Password" navigation or logic here
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: LogInHandler,
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 23,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 60),
                      ),
                    ),
                  ),
                  Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0,left: 87.0),
                    child: Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 5.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SelectUser(),));
                      },
                      child: Text(
                        'Register Now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          
                        ),
                      ),
                    ),
                  )
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
