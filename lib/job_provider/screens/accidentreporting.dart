import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccidentReportPage extends StatefulWidget {
  final String contractorId;
  final String jobId;

  const AccidentReportPage({
    super.key,
    required this.contractorId,
    required this.jobId, required String contractorname,
  });

  @override
  State<AccidentReportPage> createState() => _AccidentReportPageState();
}

class _AccidentReportPageState extends State<AccidentReportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _incidentDescriptionController =
      TextEditingController();
  final TextEditingController _injuriesController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  bool _isLoading = false;
  String? _contractorName;
  String? _jobProviderName;

  @override
  void initState() {
    super.initState();
    _fetchContractorName();
    _fetchJobProviderName();
  }

  Future<void> _fetchContractorName() async {
    try {
      DocumentSnapshot contractorDoc = await FirebaseFirestore.instance
          .collection('Contractor')
          .doc(widget.contractorId)
          .get();

      if (contractorDoc.exists) {
        setState(() {
          _contractorName = contractorDoc['name'] ?? 'Unknown Contractor';
        });
      } else {
        setState(() {
          _contractorName = 'Unknown Contractor';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching contractor name: $e')),
      );
      setState(() {
        _contractorName = 'Unknown Contractor';
      });
    }
  }

  Future<void> _fetchJobProviderName() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("User not logged in");
      }

      DocumentSnapshot jobProviderDoc = await FirebaseFirestore.instance
          .collection('Job Provider')
          .doc(currentUser.uid)
          .get();

      if (jobProviderDoc.exists) {
        setState(() {
          _jobProviderName = jobProviderDoc['name'] ?? 'Unknown Job Provider';
        });
      } else {
        setState(() {
          _jobProviderName = 'Unknown Job Provider';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching job provider name: $e')),
      );
      setState(() {
        _jobProviderName = 'Unknown Job Provider';
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _submitAccidentReport() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          throw Exception("User not logged in");
        }

        await FirebaseFirestore.instance.collection('accidentReports').add({
          'jobProviderId': currentUser.uid,
          'jobProviderName': _jobProviderName ?? 'Unknown Job Provider',
          'contractorId': widget.contractorId,
          'contractorName': _contractorName ?? 'Unknown Contractor',
          'jobId': widget.jobId,
          'incidentDescription': _incidentDescriptionController.text,
          'injuries': _injuriesController.text,
          'date': _dateController.text,
          'time': _timeController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Accident report submitted successfully!')),
        );

        // Clear the form
        _incidentDescriptionController.clear();
        _injuriesController.clear();
        _dateController.clear();
        _timeController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit report: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Accident"),
        backgroundColor: Colors.red[600],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Accident Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "Reported by: ${_jobProviderName ?? 'Loading...'}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _incidentDescriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Incident Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please provide a description of the incident.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _injuriesController,
                decoration: const InputDecoration(
                  labelText: "Injuries (if any)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please specify if there were any injuries.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Date of Incident (DD-MM-YYYY)",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please provide the date of the incident.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _timeController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Time of Incident (HH:MM)",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: _selectTime,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please provide the time of the incident.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                "Reported to/about: ${_contractorName ?? 'Loading...'}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submitAccidentReport,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          backgroundColor: Colors.red[600],
                        ),
                        child: const Text(
                          "Submit Report",
                          style: TextStyle(fontSize: 16, color: Colors.white),
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
