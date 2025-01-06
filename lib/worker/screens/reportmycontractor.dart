import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportMyContractorPage extends StatefulWidget {
  const ReportMyContractorPage({super.key});

  @override
  _ReportMyContractorPageState createState() => _ReportMyContractorPageState();
}

class _ReportMyContractorPageState extends State<ReportMyContractorPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  String? _selectedReportType;
  bool _isSubmitting = false;

  // Sample contractor user ID for demonstration
  final String _contractorUserId = "sample_contractor_id";

  final List<String> _reportTypes = [
    "Cheating or Fraudulent Activity",
    "Non-Payment Issues",
    "Unprofessional Conduct",
    "Fake Job or False Identity",
  ];

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate() && _selectedReportType != null) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser == null) {
          throw Exception("User is not logged in.");
        }

        // Save the report to Firestore
        await FirebaseFirestore.instance.collection('Reports').add({
          'type': _selectedReportType,
          'comment': _commentController.text.trim(),
          'reportedBy': currentUser.uid,
          'reportedUser': _contractorUserId,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Your report has been submitted successfully!")),
        );

        // Clear the form
        _formKey.currentState!.reset();
        _commentController.clear();
        setState(() {
          _selectedReportType = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error submitting report: $e")),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    } else if (_selectedReportType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a report type.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Report Contractor',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Report Form",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),

                // Report Type Selection
                const Text(
                  "1. Select the type of issue you want to report:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                for (String type in _reportTypes)
                  RadioListTile<String>(
                    title: Text(type, style: const TextStyle(fontSize: 16)),
                    value: type,
                    groupValue: _selectedReportType,
                    onChanged: (value) {
                      setState(() {
                        _selectedReportType = value;
                      });
                    },
                  ),
                if (_selectedReportType == null)
                  const Text(
                    "Please select a report type.",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),

                const SizedBox(height: 20),

                // Post Comment
                TextFormField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: 'Post a comment (Optional)',
                    hintText: 'Provide any extra information or evidence.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please provide some details.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Submit Report",
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
