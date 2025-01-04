import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AdminModuleApp());
}

class AdminModuleApp extends StatelessWidget {
  const AdminModuleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green, // Green theme
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0xFFE8F5E9), // Light green background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C6B2F), // Dark green app bar background
          foregroundColor: Colors.white, // White text in the app bar
          elevation: 4, // Add elevation for better shadow effect
          centerTitle: true, // Center the title in the AppBar
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5, // For a more spacious title
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.green, // Green bottom navigation bar
          selectedItemColor: Colors.white, // White selected icon color
          unselectedItemColor:
              Colors.white60, // Lighter white for unselected icons
        ),
      ),
      home: WorkerListScreen(),
    );
  }
}

class WorkerListScreen extends StatelessWidget {
  const WorkerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Worker').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          final contractors = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: contractors.length,
            itemBuilder: (context, index) {
              final contractorData =
                  contractors[index].data() as Map<String, dynamic>;

              // Extract data
              final name = contractorData['name'] ?? 'N/A';
              final companyName = contractorData['companyName'] ?? 'N/A';
              final address = contractorData['address'] ?? 'N/A';
              final phone = contractorData['phone'] ?? 'N/A';
              final email = contractorData['email'] ?? 'N/A';
              final skill = contractorData['skill'] ?? 'N/A';
              final role = contractorData['role'] ?? 'N/A';
              final profilePicture = contractorData['profilePicture'] ?? 'N/A';

              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green.shade50, // Light green background
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile picture section
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: profilePicture.isNotEmpty
                          ? NetworkImage(profilePicture)
                          : const AssetImage('assets/default_profile.png')
                              as ImageProvider,
                      backgroundColor: Colors.green.shade100,
                    ),
                    const SizedBox(width: 15),

                    // Contractor details section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name and company name
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Company: $companyName',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade600,
                            ),
                          ),
                          Divider(color: Colors.green.shade300, thickness: 1),

                          // Address and phone
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Address:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade500,
                                ),
                              ),
                              Text(
                                address,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Phone:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade500,
                                ),
                              ),
                              Text(
                                phone,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Email:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade500,
                                ),
                              ),
                              Text(
                                email,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Skill:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade500,
                                ),
                              ),
                              Text(
                                skill,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Role:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade500,
                                ),
                              ),
                              Text(
                                role,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Delete button
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red.shade700,
                              ),
                              onPressed: () {
                                // Code to delete the contractor from Firestore
                                FirebaseFirestore.instance
                                    .collection('Contractor')
                                    .doc(contractors[index].id)
                                    .delete();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Contractor {
  final String name;
  final String address;
  final String companyName;
  final String phone;
  final String email;
  final String skill;
  final String role;

  Contractor({
    required this.name,
    required this.address,
    required this.companyName,
    required this.phone,
    required this.email,
    required this.skill,
    required this.role,
  });

  factory Contractor.fromMap(Map<String, dynamic> data) {
    return Contractor(
      name: data['name'] ?? 'N/A',
      address: data['address'] ?? 'N/A',
      companyName: data['companyName'] ?? 'N/A',
      phone: data['phone'] ?? 'N/A',
      email: data['email'] ?? 'N/A',
      skill: data['skill'] ?? 'N/A',
      role: data['role'] ?? 'N/A',
    );
  }
}
