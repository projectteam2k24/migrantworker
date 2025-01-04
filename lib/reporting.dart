import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportContractorPage extends StatefulWidget {
  const ReportContractorPage({super.key});

  @override
  _ReportContractorPageState createState() => _ReportContractorPageState();
}

class _ReportContractorPageState extends State<ReportContractorPage> {
  final _formKey = GlobalKey<FormState>();

  String? incorrectDetails;
  bool isFakeInformation = false;
  String? fakeInfoDetails;
  bool isNameAddressMismatch = false;
  String? nameAddressDetails;
  bool? isProfilePictureAuthentic;  // Changed to nullable to avoid preset tick
  String? profilePictureExplanation;
  String? otherConcerns;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitReport() async {
    // Check if the first question (reason for reporting) is not empty
    if (incorrectDetails == null || incorrectDetails!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a valid reason for Reporting the User')),
      );
      return; // Return early if the first question is not filled
    }

    try {
      // Gather all form data
      Map<String, dynamic> reportData = {
        'incorrectDetails': incorrectDetails ?? '',
        'isFakeInformation': isFakeInformation,
        'fakeInfoDetails': fakeInfoDetails ?? '',
        'isNameAddressMismatch': isNameAddressMismatch,
        'nameAddressDetails': nameAddressDetails ?? '',
        'isProfilePictureAuthentic': isProfilePictureAuthentic ?? true, // Default to true if null
        'profilePictureExplanation': profilePictureExplanation ?? '',
        'otherConcerns': otherConcerns ?? '',
        'timestamp': FieldValue.serverTimestamp(),  // Add timestamp to record
      };

      // Send data to Firebase
      await _firestore.collection('Reports').add(reportData);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your report has been submitted successfully!')),
      );
    } catch (e) {
      // Handle any errors that occur during the submission process
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit the report. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Contractor'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                "Report Contractor Form",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 20),

              // Question 1: Reason for reporting
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(2, 2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Why are you reporting this contractor?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      onChanged: (value) => incorrectDetails = value,
                      decoration: const InputDecoration(
                        hintText: 'Enter details of why you are reporting',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),

              // Question 2: Is there fake information?
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(2, 2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2. Is the contractor providing fake information?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isFakeInformation,
                          onChanged: (value) {
                            setState(() {
                              isFakeInformation = value ?? false;
                            });
                          },
                        ),
                        const Text(
                          'Yes, fake information provided',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    if (isFakeInformation)
                      TextFormField(
                        onChanged: (value) => fakeInfoDetails = value,
                        decoration: const InputDecoration(
                          hintText: 'Provide details about the fake information',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                  ],
                ),
              ),

              // Question 3: Is there a name or address mismatch?
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(2, 2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3. Is there a name/address mismatch?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isNameAddressMismatch,
                          onChanged: (value) {
                            setState(() {
                              isNameAddressMismatch = value ?? false;
                            });
                          },
                        ),
                        const Text(
                          'Yes, there is a mismatch',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    if (isNameAddressMismatch)
                      TextFormField(
                        onChanged: (value) => nameAddressDetails = value,
                        decoration: const InputDecoration(
                          hintText: 'Provide details about the mismatch',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                  ],
                ),
              ),

              // Question 4: Is profile picture authentic?
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(2, 2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '4. Is the profile picture authentic?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isProfilePictureAuthentic ?? true,  // Default to false if null
                          onChanged: (value) {
                            setState(() {
                              isProfilePictureAuthentic = value;
                            });
                          },
                        ),
                        const Text(
                          'Yes, the profile picture is authentic',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    if (isProfilePictureAuthentic == false)
                      TextFormField(
                        onChanged: (value) => profilePictureExplanation = value,
                        decoration: const InputDecoration(
                          hintText: 'Provide details about the profile picture',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                  ],
                ),
              ),

              // Question 5: Other concerns
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      offset: const Offset(2, 2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '5. Any other concerns?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    TextFormField(
                      onChanged: (value) => otherConcerns = value,
                      decoration: const InputDecoration(
                        hintText: 'Provide any additional concerns',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Submit button - Centered and Increased Width
              Center(
                child: SizedBox(
                  width: double.infinity, // To make the button take full width
                  child: ElevatedButton(
                    onPressed: submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Submit Report'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
