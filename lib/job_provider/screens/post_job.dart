import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:migrantworker/job_provider/screens/homepage.dart';
import 'package:cloudinary/cloudinary.dart';

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
  final TextEditingController nameController = TextEditingController();
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
                    _buildTextField('Company/House Name',
                        'Enter Company/House Name', nameController,
                        required: false),
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
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return PostJobPage1(
                              selectedPropertyType: selectedPropertyType,
                              jobType: jobTypeController.text,
                              selectedDistrict: selectedDistrict,
                              selectedTown: selectedTown,
                              name : nameController,
                              landMark: landmarkController.text,
                              address: addressController.text,
                              phone: contactController.text,
                              plotSize: plotSizeController.text,
                              rooms: roomsController.text,
                              floors: floorsController.text,
                            );
                          },
                        ));
                      }
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
  const PostJobPage1({
    super.key,
    required this.selectedPropertyType,
    required this.jobType,
    required this.selectedDistrict,
    required this.selectedTown,
    required this.name,
    required this.landMark,
    required this.address,
    required this.phone,
    required this.plotSize,
    required this.rooms,
    required this.floors,
  });

  final String? selectedPropertyType;
  final String jobType;
  final String? selectedDistrict;
  final String? selectedTown;
  final String landMark;
  final String address;
  final String phone;
  final String plotSize;
  final String rooms;
  final String floors;
  
  final dynamic name;

  @override
  State<PostJobPage1> createState() => _PostJobPage1State();
}

class _PostJobPage1State extends State<PostJobPage1> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController propertyDescriptionController =
      TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Cloudinary configuration
  final Cloudinary _cloudinary = Cloudinary.signedConfig(
    apiKey: '714694759259219',
    apiSecret: '-yv1E3csFWNunS7jYdQn1eQatz4',
    cloudName: 'diskdblly',
  );

  final List<String> _imageUrls = [];
  bool _isLoading = false;

  Future<void> _uploadImages(List<XFile> images) async {
    setState(() {
      _isLoading = true;
    });

    try {
      for (var image in images) {
        // Upload to Cloudinary
        final response = await _cloudinary.upload(
          file: image.path,
          fileBytes: File(image.path).readAsBytesSync(),
          resourceType: CloudinaryResourceType.image,
          folder: 'job_images', // Optional folder
        );

        if (response.isSuccessful) {
          _imageUrls.add(response.secureUrl!);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('${_imageUrls.length} images uploaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading images: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _postJob() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }

        final jobData = {
          'uid': user.uid,
          'propertyType': widget.selectedPropertyType,
          'jobType': widget.jobType,
          'district': widget.selectedDistrict,
          'town': widget.selectedTown,
          'name' : widget.name,
          'landmark': widget.landMark,
          'address': widget.address,
          'contactNumber': widget.phone,
          'plotSize': widget.plotSize,
          'rooms': widget.rooms,
          'floors': widget.floors,
          'propertyDescription': propertyDescriptionController.text,
          'images': _imageUrls,
          'createdAt': FieldValue.serverTimestamp(),
        };

        // Save to Firestore
        await FirebaseFirestore.instance.collection('Jobs').add(jobData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job Posted Successfully!')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const JobProviderHome(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
                  // Upload Images Section
                  _buildCard('Upload Images', [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.upload),
                      label: const Text('Upload Images'),
                      onPressed: () async {
                        final pickedFiles = await _picker.pickMultiImage();
                        if (pickedFiles.isNotEmpty) {
                          await _uploadImages(pickedFiles);
                        }
                      },
                    ),
                    if (_imageUrls.isNotEmpty)
                      Column(
                        children: _imageUrls.map((url) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Image.network(url, height: 100),
                          );
                        }).toList(),
                      ),
                  ]),
                  const SizedBox(height: 16),
                  // Property Description Section
                  _buildCard('Property Description', [
                    _buildTextField(
                      'Property Description',
                      'Enter property description',
                      propertyDescriptionController,
                      maxLines: 5,
                    ),
                  ]),
                  const SizedBox(height: 30),
                  // Submit Button
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _postJob,
                          child: const Text('Post Job'),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
