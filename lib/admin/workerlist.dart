import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AdminModuleApp());
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
      ),
      home: const WorkerListScreen(),
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

          final workers = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: workers.length,
            itemBuilder: (context, index) {
              final workerData = workers[index].data() as Map<String, dynamic>;

              // Extract data safely
              final name = workerData['name'] ?? 'N/A';
              final address = workerData['address'] ?? 'N/A';
              final phone = workerData['phone'] ?? 'N/A';
              final email = workerData['email'] ?? 'N/A';
              final skill = workerData['skill'] ?? 'N/A';
              final profilePicture = workerData['profilePicture'] ?? '';
              final govtID = workerData['govtID'] ?? '';
              final POACertificate = workerData['AddressProof'] ?? '';

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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

                    // Worker details section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
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
                            'Address: $address',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade600,
                            ),
                          ),
                          Divider(color: Colors.green.shade300, thickness: 1),

                          // Phone and email
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Phone:',
                                style: TextStyle(fontSize: 14, color: Colors.green.shade500),
                              ),
                              Text(
                                phone,
                                style: TextStyle(fontSize: 14, color: Colors.green.shade500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Email:',
                                style: TextStyle(fontSize: 14, color: Colors.green.shade500),
                              ),
                              Text(
                                email,
                                style: TextStyle(fontSize: 14, color: Colors.green.shade500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Skill:',
                                style: TextStyle(fontSize: 14, color: Colors.green.shade500),
                              ),
                              Text(
                                skill,
                                style: TextStyle(fontSize: 14, color: Colors.green.shade500),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Document buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: POACertificate.isNotEmpty
                                    ? () => _openDocument(POACertificate)
                                    : null,
                                icon: const Icon(Icons.account_balance),
                                label: const Text("Proof of Address"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: POACertificate.isNotEmpty ? Colors.blue : Colors.grey,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: govtID.isNotEmpty
                                    ? () => _openDocument(govtID)
                                    : null,
                                icon: const Icon(Icons.business),
                                label: const Text("Govt ID"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: govtID.isNotEmpty ? Colors.orange : Colors.grey,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Delete button with confirmation
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red.shade700),
                              onPressed: () {
                                _confirmDelete(context, workers[index].id);
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

  // Function to open document links
  void _openDocument(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  // Function to confirm deletion
  void _confirmDelete(BuildContext context, String workerId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Delete Worker"),
          content: const Text("Are you sure you want to delete this worker?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('Worker').doc(workerId).delete();
                Navigator.pop(dialogContext);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
