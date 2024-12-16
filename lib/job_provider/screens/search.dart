import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contractor {
  final String name;
  final String profession;
  final String contactDetails;
  final String photoUrl;
  final String about;
  final String location;
  final String skills;
  final List<String> certifications;
  final List<String> portfolioLinks;
  final List<String> reviews;
  final String phoneNumber;
  final String email;

  const Contractor({
    required this.name,
    required this.profession,
    required this.contactDetails,
    required this.photoUrl,
    required this.about,
    required this.location,
    required this.skills,
    required this.certifications,
    required this.portfolioLinks,
    required this.reviews,
    required this.phoneNumber,
    required this.email,
  });
}

class ContractorSearch extends StatelessWidget {
  // Sample contractor with additional fields
  final Contractor contractor = const Contractor(
    name: 'John Doe',
    profession: 'Plumber',
    contactDetails: 'john.doe@email.com\n(555) 123-4567',
    photoUrl:
        'assets/john_doe.jpg', // Make sure this image exists in the assets
    about:
        'Experienced plumber specializing in residential and commercial plumbing services.',
    location: 'New York, NY',
    skills: 'Plumbing, Pipe Installation, Leak Detection, Bathroom Renovation',
    certifications: [
      'Certified Plumbing Technician',
      'Licensed Master Plumber'
    ],
    portfolioLinks: [
      'https://portfolio.com/johndoe',
      'https://github.com/johndoe'
    ],
    reviews: ['Great work! Highly recommend.', 'Professional and reliable.'],
    phoneNumber: '(555) 123-4567',
    email: 'john.doe@email.com',
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contractor Search',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[700],
          title: const Text(
            'Contractor Search',
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
            child: Column(
              children: [
                _buildContractorCard(contractor, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContractorCard(Contractor contractor, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContractorDetailPage(contractor: contractor),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Contractor's photo
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(contractor.photoUrl),
              ),
              const SizedBox(width: 16),
              // Contractor's details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contractor.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contractor.profession,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      contractor.contactDetails,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // View Details button (Arrow icon)
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContractorDetailPage extends StatelessWidget {
  final Contractor contractor;

  const ContractorDetailPage({required this.contractor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('${contractor.name} Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Wrapping the body with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Picture and Details
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(contractor.photoUrl),
              ),
              const SizedBox(height: 20),
              Text(
                contractor.name,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                contractor.profession,
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
              const SizedBox(height: 20),
              // About Section
              _buildProfileSection(
                title: 'About Me',
                content: contractor.about,
              ),
              const SizedBox(height: 20),
              // Location Section
              _buildProfileSection(
                title: 'Location',
                content: contractor.location,
              ),
              const SizedBox(height: 20),
              // Skills Section
              _buildProfileSection(
                title: 'Skills',
                content: contractor.skills,
              ),
              const SizedBox(height: 20),
              // Certifications Section
              _buildProfileSection(
                title: 'Certifications',
                content: contractor.certifications.join(', '),
              ),
              const SizedBox(height: 20),
              // Portfolio Links
              _buildProfileSection(
                title: 'Portfolio',
                content: contractor.portfolioLinks.join(', '),
              ),
              const SizedBox(height: 20),
              // Reviews Section
              _buildProfileSection(
                title: 'Reviews',
                content: contractor.reviews.join('\n'),
              ),
              const SizedBox(height: 30),
              // Call Button
              ElevatedButton.icon(
                onPressed: () {
                  _makeCall(contractor.phoneNumber);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                icon: const Icon(Icons.phone),
                label: const Text('Call Contractor'),
              ),
              const SizedBox(height: 20),
              // Message Button
              ElevatedButton.icon(
                onPressed: () {
                  _sendEmail(contractor.email);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                icon: const Icon(Icons.email),
                label: const Text('Message Contractor'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(
      {required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not send email to $email';
    }
  }
}

void main() {
  runApp(ContractorSearch());
}
