import 'package:flutter/material.dart';

class JobStatusPage extends StatefulWidget {
  const JobStatusPage({super.key});

  @override
  State<JobStatusPage> createState() => _JobStatusPageState();
}

class _JobStatusPageState extends State<JobStatusPage> {
  // Form field controllers for job status
  final TextEditingController progressController = TextEditingController();
  final TextEditingController jobStartDateController = TextEditingController();
  final TextEditingController jobCompletionDateController = TextEditingController();
  final TextEditingController jobUpdatesController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Status',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text(
            'Job Status',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Times New Roman',
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Job Status Card
                _buildCard('Job Status', [
                  _buildTextField('Job Progress (%)',
                      'Enter the current progress of the job (in %)', progressController,
                      inputType: TextInputType.number),
                  _buildTextField('Job Start Date',
                      'Enter the start date of the job', jobStartDateController,
                      inputType: TextInputType.datetime),
                  _buildTextField('Job Completion Date',
                      'Enter the expected or actual completion date', jobCompletionDateController,
                      inputType: TextInputType.datetime),
                ]),
                const SizedBox(height: 16),
                // Updates Card
                _buildCard('Job Updates', [
                  _buildTextField('Job Updates',
                      'Enter any relevant updates regarding the job', jobUpdatesController,
                      inputType: TextInputType.text, required: false, maxLines: 5),
                ]),
                const SizedBox(height: 16),
                // Remarks Card
                _buildCard('Remarks', [
                  _buildTextField('Remarks',
                      'Enter any remarks or comments regarding the job', remarksController,
                      inputType: TextInputType.text, required: false, maxLines: 3),
                ]),
                const SizedBox(height: 30),
                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    backgroundColor: Colors.green[700],
                  ),
                  onPressed: () {
                    // You can add functionality for submitting status or saving the job status
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Job Status Updated!')),
                    );
                  },
                  child: const Text(
                    'UPDATE STATUS',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Card widget for grouping related fields
  Widget _buildCard(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)), // borderRadius set to 20
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  // Text field widget
  Widget _buildTextField(
      String label, String hint, TextEditingController controller,
      {TextInputType inputType = TextInputType.text,
      bool required = true,
      int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines, // Set the number of lines based on the label
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // borderRadius set to 20
            borderSide: const BorderSide(color: Colors.green),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // borderRadius set to 20
            borderSide: const BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // borderRadius set to 20
            borderSide: const BorderSide(color: Colors.green, width: 2.0),
          ),
        ),
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
