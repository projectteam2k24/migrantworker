import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContractorSearchPage extends StatefulWidget {
  const ContractorSearchPage({super.key, required String query});

  @override
  _ContractorSearchPageState createState() => _ContractorSearchPageState();
}

class _ContractorSearchPageState extends State<ContractorSearchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,  // Changed the AppBar color to green
        title: const Text(
          'Contractor Search',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(child: _buildContractorList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Search by Contractor Name',
        hintText: 'Enter name to search...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
      ),
    );
  }

  Widget _buildContractorList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Contractor').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Failed to load contractors. Please try again later.',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No contractors found.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final contractors = snapshot.data!.docs.where((doc) {
          return doc['name']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
        }).toList();

        return ListView.builder(
          itemCount: contractors.length,
          itemBuilder: (context, index) {
            final contractor = contractors[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: contractor['profilePicture'] != null
                              ? NetworkImage(contractor['profilePicture'])
                              : const AssetImage('assets/person_icon.png') as ImageProvider,
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contractor['name'] ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 24,  // Increased font size for name
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            contractor['companyName'] ?? 'No Company Name',
                            style: const TextStyle(
                              fontSize: 20,  // Increased font size for company name
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            contractor['address'] ?? 'No Address',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            contractor['email'] ?? 'No Email',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            contractor['phone'] ?? 'No Phone',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ContractorDetailPage extends StatelessWidget {
  final QueryDocumentSnapshot contractor;

  const ContractorDetailPage({super.key, required this.contractor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,  // Changed the AppBar color to green
        title: Text('${contractor['name']} Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage: contractor['profilePicture'] != null
                  ? NetworkImage(contractor['profilePicture'])
                  : const AssetImage('assets/person_icon.png') as ImageProvider,
            ),
            const SizedBox(height: 20),
            Text(
              contractor['name'] ?? 'No Name',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              contractor['companyName'] ?? 'No Company Name',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.green),
            ),
            const SizedBox(height: 20),
            _buildDetailSection(contractor['address']),
            _buildDetailSection(contractor['email']),
            _buildDetailSection(contractor['phone']),
            _buildDetailSection(contractor['dob']),
            _buildDetailSection(contractor['experience']),
            _buildDetailSection(contractor['gender']),
            _buildDetailSection(contractor['skill']),
            _buildDetailSection(contractor['companyCertificate']),
            _buildDetailSection(contractor['govtID']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(dynamic content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2F1), // Light Teal Color
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(2, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                content ?? 'Not available',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
