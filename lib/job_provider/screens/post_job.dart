import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostJobPage extends StatefulWidget {
  const PostJobPage({super.key});

  @override
  State<PostJobPage> createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown values
  String? selectedDistrict;
  String? selectedTown;
  List<String> towns = [];
  String? selectedPropertyType; // To hold the selected property type

  // Districts and corresponding towns
  final Map<String, List<String>> keralaTowns = {
    'Thiruvananthapuram': ['Kazhakoottam', 'Neyyattinkara', 'Varkala'],
    'Kollam': ['Kottarakkara', 'Punalur', 'Paravur'],
    'Pathanamthitta': ['Adoor', 'Pandalam', 'Thiruvalla'],
    'Alappuzha': ['Cherthala', 'Kayamkulam', 'Haripad'],
    'Kottayam': ['Changanassery', 'Pala', 'Ettumanoor'],
    'Idukki': ['Thodupuzha', 'Munnar', 'Nedumkandam'],
    'Ernakulam': ['Kochi', 'Aluva', 'Perumbavoor'],
    'Thrissur': ['Guruvayur', 'Chalakudy', 'Irinjalakuda'],
    'Palakkad': ['Shoranur', 'Mannarkkad', 'Ottappalam'],
    'Malappuram': ['Manjeri', 'Perinthalmanna', 'Tirur'],
    'Kozhikode': ['Vadakara', 'Koyilandy', 'Balussery'],
    'Wayanad': ['Kalpetta', 'Sulthan Bathery', 'Mananthavady'],
    'Kannur': ['Taliparamba', 'Payyanur', 'Mattannur'],
    'Kasaragod': ['Kanhangad', 'Uppala', 'Bekal'],
  };

  // Form field controllers
  final TextEditingController jobTypeController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController plotSizeController = TextEditingController();
  final TextEditingController roomsController = TextEditingController();
  final TextEditingController floorsController = TextEditingController();
  final TextEditingController jobDescriptionController =
      TextEditingController();
  final TextEditingController imageController =
      TextEditingController(); // For image description (filename)

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post Job',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text(
            'Post Job',
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildCard('Property Details', [
                    _buildDropdownField(
                      'Property Type',
                      'Select Property Type',
                      ['Residential', 'Industrial', 'Commercial', 'Others'],
                      (value) {
                        setState(() {
                          selectedPropertyType = value;
                        });
                      },
                      selectedPropertyType,
                    ),
                    _buildTextField('Job Type',
                        'Enter job type (e.g., Painting)', jobTypeController),
                  ]),
                  const SizedBox(height: 16),
                  _buildCard('Location Details', [
                    _buildDropdownField('District', 'Select District',
                        keralaTowns.keys.toList(), (value) {
                      setState(() {
                        selectedDistrict = value;
                        towns = keralaTowns[value!]!;
                        selectedTown = null;
                      });
                    }, selectedDistrict),
                    _buildDropdownField('Town', 'Select Town', towns, (value) {
                      setState(() {
                        selectedTown = value;
                      });
                    }, selectedTown),
                    _buildTextField('Landmark',
                        'Enter nearby landmark (optional)', landmarkController,
                        required: false),
                    _buildTextField('Property Address',
                        'Enter property address', addressController),
                  ]),
                  const SizedBox(height: 16),
                  _buildCard('Contact Details', [
                    _buildTextField('Contact Number', 'Enter contact number',
                        contactController,
                        inputType: TextInputType.phone),
                  ]),
                  const SizedBox(height: 16),
                  _buildCard('Property Description', [
                    _buildTextField('Plot Size (sq ft)',
                        'Enter plot size in square feet', plotSizeController,
                        inputType: TextInputType.number),
                    _buildTextField('Number of Rooms',
                        'Enter total number of rooms', roomsController,
                        inputType: TextInputType.number),
                    _buildTextField('Number of Floors',
                        'Enter total number of floors', floorsController,
                        inputType: TextInputType.number),
                  ]),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      backgroundColor: Colors.green[700],
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Job Posted Successfully!')),
                        );
                      }
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const PostJobPage1();
                        },
                      ));
                    },
                    child: const Text(
                      'NEXT',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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

  Widget _buildCard(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)), // Set borderRadius to 20
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

  Widget _buildTextField(
      String label, String hint, TextEditingController controller,
      {TextInputType inputType = TextInputType.text, bool required = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Set borderRadius to 20
            borderSide: const BorderSide(color: Colors.green),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Set borderRadius to 20
            borderSide: const BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Set borderRadius to 20
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

  Widget _buildDropdownField(String label, String hint, List<String> items,
      void Function(String?) onChanged, String? selectedValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: hint,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Set borderRadius to 20
            borderSide: const BorderSide(color: Colors.green),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Set borderRadius to 20
            borderSide: const BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Set borderRadius to 20
            borderSide: const BorderSide(color: Colors.green, width: 2.0),
          ),
        ),
        value: selectedValue,
        hint: Text(hint),
        onChanged: onChanged,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
    );
  }
}

class PostJobPage1 extends StatefulWidget {
  const PostJobPage1({super.key});

  @override
  State<PostJobPage1> createState() => _PostJobPage1State();
}

class _PostJobPage1State extends State<PostJobPage1> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the fields
  final TextEditingController propertyDescriptionController =
      TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Variables to hold selected image files
  List<XFile>? _images = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post Job Details',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text(
            'Post Job',
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Upload Images
                  _buildCard('Upload Images', [
                    _buildFileUploadButton(),
                    if (_images != null && _images!.isNotEmpty)
                      Column(
                        children: _images!.map((image) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width - 32,
                            child: Image.file(
                              File(image.path),
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                      ),
                  ]),
                  const SizedBox(height: 16),
                  // Property Description
                  _buildCard('Property Description', [
                    _buildTextField(
                        'Property Description',
                        'Enter property description',
                        propertyDescriptionController,
                        inputType: TextInputType.text,
                        required: false,
                        maxLines: 5),
                  ]),
                  const SizedBox(height: 30),
                  // Post Job Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      backgroundColor: Colors.green[700],
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Job Posted Successfully!')),
                        );
                      }
                    },
                    child: const Text(
                      'Post Job',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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

  // Image upload button widget
  Widget _buildFileUploadButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width -
            32, // Same width as description field
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            backgroundColor: Colors.green[700],
          ),
          onPressed: () async {
            // Allow the user to select two images
            final pickedFiles = await _picker.pickMultiImage();
            if (pickedFiles.isNotEmpty) {
              setState(() {
                _images = pickedFiles;
              });
            }
          },
          icon: const Icon(Icons.attach_file, color: Colors.white),
          label: const Text(
            'Upload Images',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
