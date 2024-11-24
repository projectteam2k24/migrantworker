import 'package:flutter/material.dart';

class AddExistingWorker extends StatefulWidget {
  const AddExistingWorker({super.key});

  @override
  State<AddExistingWorker> createState() => _AddExistingWorkerState();
}

class _AddExistingWorkerState extends State<AddExistingWorker> {
  final _formKey = GlobalKey<FormState>(); // Key to manage the form state
  TextEditingController emailOrPhoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  @override
  void dispose() {
    emailOrPhoneController.dispose();
    dobController.dispose();
    super.dispose();
  }

  // Handler to manage form submission
  void addExistingWorkerHandler() {
    if (_formKey.currentState?.validate() ?? false) {
      // Proceed with further actions like calling an API, etc.
      print('Email/Phone: ${emailOrPhoneController.text}');
      print('Date of Birth: ${dobController.text}');
      // Navigate or perform any other logic here
    } else {
      print('Form is invalid');
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
                            'Add Existing Worker',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontFamily: 'Times New Roman',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          buildTextField(
                            controller: emailOrPhoneController,
                            label: 'Email or Phone Number',
                            icon: Icons.email,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email or phone number';
                              } else if (!RegExp(r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$')
                                  .hasMatch(value) &&
                                  !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                return 'Please enter a valid email or phone number';
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
                                controller: dobController,
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
                                    return 'Please select a date of birth';
                                  }
                                  return null;
                                },
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  DateTime? selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                    builder: (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: Colors.green, // Header background color
                                            onPrimary: Colors.white, // Header text color
                                            onSurface: Colors.green, // Body text color
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.green, // Button text color
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );

                                  if (selectedDate != null) {
                                    dobController.text = "${selectedDate.toLocal()}"
                                        .split(' ')[0]; // YYYY-MM-DD
                                  }
                                },
                                readOnly: true, // Prevent manual text input
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: ElevatedButton(
                              onPressed: addExistingWorkerHandler,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 50),
                                backgroundColor: Colors.green[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Add Worker",
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: validator,
        ),
      ),
    );
  }
}