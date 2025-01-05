import 'package:flutter/material.dart';

class ReportMyContractorPage extends StatefulWidget {
  const ReportMyContractorPage({super.key});

  @override
  _ReportMyContractorPageState createState() => _ReportMyContractorPageState();
}

class _ReportMyContractorPageState extends State<ReportMyContractorPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "primaryConcern": "",
    "cheatingFraudulent": false,
    "nonPayment": false,
    "unprofessionalConduct": false,
    "fakeJobIdentity": false,
    "additionalDetails": "",
  };

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Simulate a form submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your report has been submitted successfully!")),
      );

      // Clear the form (optional)
      _formKey.currentState!.reset();
      setState(() {
        _formData.updateAll((key, value) => value is bool ? false : "");
      });
    }
  }

  Widget _buildQuestionCheckbox({
    required String title,
    required String formFieldKey,
  }) {
    return Row(
      children: [
        Checkbox(
          value: _formData[formFieldKey],
          onChanged: (bool? value) {
            setState(() {
              _formData[formFieldKey] = value ?? false;
            });
          },
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
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

                // Question 1: Primary Concern (Mandatory)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '1. What is your primary reason for reporting the contractor?',
                    hintText: 'Provide a clear and detailed reason.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                  onSaved: (value) => _formData["primaryConcern"] = value?.trim(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "This field is required.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Question 2: Cheating or Fraudulent Activity
                _buildQuestionCheckbox(
                  title: "Did the contractor engage in any cheating or fraudulent activity?",
                  formFieldKey: "cheatingFraudulent",
                ),

                // Question 3: Non-Payment Issues
                _buildQuestionCheckbox(
                  title: "Has the contractor failed to make agreed-upon payments?",
                  formFieldKey: "nonPayment",
                ),

                // Question 4: Unprofessional Conduct
                _buildQuestionCheckbox(
                  title: "Did the contractor exhibit unprofessional or inappropriate behavior?",
                  formFieldKey: "unprofessionalConduct",
                ),

                // Question 5: Fake Job or False Identity
                _buildQuestionCheckbox(
                  title: "Do you believe the contractor's job post or identity is fake?",
                  formFieldKey: "fakeJobIdentity",
                ),

                const SizedBox(height: 20),

                // Additional Details (Optional)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Additional Details (Optional)',
                    hintText: 'Provide any extra information or evidence.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                  onSaved: (value) => _formData["additionalDetails"] = value?.trim(),
                ),
                const SizedBox(height: 20),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
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
                    child: const Text(
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
