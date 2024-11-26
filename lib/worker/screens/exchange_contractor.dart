import 'package:flutter/material.dart';

class ContractorExchangePage extends StatelessWidget {
  const ContractorExchangePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contractor Exchange',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Contractor Exchange',
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
                const SizedBox(height: 20),
                _buildSectionTitle('Current Contractor Details'),
                _buildTextField('Contractor Name', 'John Doe'),
                _buildTextField('Contractor ID/Ref', 'CNT12345'),
                _buildTextField(
                    'Current Job Assigned', 'Building Construction'),
                const SizedBox(height: 20),
                _buildSectionTitle('New Contractor Details'),
                _buildDropdown('Select New Contractor',
                    ['Contractor A', 'Contractor B', 'Contractor C']),
                _buildTextField('Reason for Exchange', 'Enter reason'),
                const SizedBox(height: 20),
                _buildSectionTitle('Job Transfer Details'),
                _buildTextField('Job ID/Reference', 'JOB56789'),
                _buildTextField('Location of Job', 'Main Street, City',
                    readOnly: true),
                _buildTextField('Number of Workers', '12'),
                const SizedBox(height: 20),
                _buildSectionTitle('Optional Note'),
                _buildTextField('Additional Details', 'Enter details here'),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      // Handle exchange request logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Exchange request submitted successfully!')),
                      );
                    },
                    child: const Text(
                      'Request Exchange',
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green,
          fontFamily: 'Times New Roman',
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.green, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    String? selectedValue;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (value) {
          selectedValue = value!;
        },
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.green, width: 2),
          ),
        ),
      ),
    );
  }
}
