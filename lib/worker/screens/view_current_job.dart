import 'package:flutter/material.dart';

class ViewCurrentJobPage extends StatelessWidget {
  const ViewCurrentJobPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Demo values for job details
    final Map<String, String> jobDetails = {
      'propertyType': 'Residential',
      'jobType': 'Painting',
      'district': 'Kozhikode',
      'town': 'Vadakara',
      'landmark': 'Near Beach Road',
      'address': '123, Green Villa, Main Street',
      'contactNumber': '+91 9876543210',
      'plotSize': '1500',
      'rooms': '3',
      'floors': '2',
    };

    return MaterialApp(
      title: 'View Current Job',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white), // White back button
            onPressed: () {
              Navigator.pop(context); // Navigate to the previous page
            },
          ),
          title: const Text(
            'Current Job Details',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Times New Roman',
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCard('Property Details', [
                  _buildDetailItem('Property Type', jobDetails['propertyType']!),
                  _buildDetailItem('Job Type', jobDetails['jobType']!),
                ]),
                const SizedBox(height: 16),
                _buildCard('Location Details', [
                  _buildDetailItem('District', jobDetails['district']!),
                  _buildDetailItem('Town', jobDetails['town']!),
                  _buildDetailItem('Landmark', jobDetails['landmark']!),
                  _buildDetailItem('Property Address', jobDetails['address']!),
                ]),
                const SizedBox(height: 16),
                _buildCard('Property Description', [
                  _buildDetailItem('Plot Size (sq ft)', jobDetails['plotSize']!),
                  _buildDetailItem('Number of Rooms', jobDetails['rooms']!),
                  _buildDetailItem('Number of Floors', jobDetails['floors']!),
                ]),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      backgroundColor: Colors.green[700],
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Navigate back to the previous page
                    },
                    child: const Text(
                      'Back to Dashboard',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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

  Widget _buildCard(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
