import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0xFFE8F5E9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C6B2F),
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      home: const ContractorListScreen(),
    );
  }
}

class ContractorListScreen extends StatelessWidget {
  const ContractorListScreen({super.key});

  // Function to open document URLs
  void _openDocument(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Fluttertoast.showToast(
        msg: "Could not open document",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contractor List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Contractor').snapshots(),
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

              // Extract data safely
              final name = contractorData['name'] ?? 'N/A';
              final companyName = contractorData['companyName'] ?? 'N/A';
              final phone = contractorData['phone'] ?? 'N/A';
              final email = contractorData['email'] ?? 'N/A';
              final skill = contractorData['skill'] ?? 'N/A';
              final role = contractorData['role'] ?? 'N/A';
              final profilePicture = contractorData['profilePicture'] ?? '';
              final govtID = contractorData['govtID']; // Government ID URL
              final companyCertificate =
                  contractorData['companyCertificate']; // Company Certificate URL

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile picture
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green.shade100,
                          backgroundImage: (profilePicture.isNotEmpty)
                              ? NetworkImage(profilePicture)
                              : null,
                          child: (profilePicture.isEmpty)
                              ? const Icon(Icons.person, size: 30, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 15),

                        // Contractor details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                              Text(
                                'Phone: $phone',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Email: $email',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Skill: $skill',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Role: $role',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.green.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Document Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: (govtID != null && govtID.isNotEmpty)
                              ? () => _openDocument(govtID)
                              : null, // Disabled if URL is null/empty
                          icon: const Icon(Icons.account_balance),
                          label: const Text("Govt ID"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                (govtID != null && govtID.isNotEmpty) ? Colors.blue : Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: (companyCertificate != null &&
                                  companyCertificate.isNotEmpty)
                              ? () => _openDocument(companyCertificate)
                              : null, // Disabled if URL is null/empty
                          icon: const Icon(Icons.business),
                          label: const Text("Company Certificate"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (companyCertificate != null &&
                                    companyCertificate.isNotEmpty)
                                ? Colors.orange
                                : Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Delete button
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red.shade700),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('Contractor')
                              .doc(contractors[index].id)
                              .delete();
                          Fluttertoast.showToast(
                            msg: "Contractor deleted successfully",
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                        },
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
