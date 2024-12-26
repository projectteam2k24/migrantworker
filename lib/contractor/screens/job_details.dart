import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailsPage extends StatefulWidget {
  final Map<String, dynamic> job;
  final String jobId;
  const JobDetailsPage({super.key, required this.job, required this.jobId});

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  bool isJobAssigned = false; // Track if the job has been assigned.

  @override
  void initState() {
    super.initState();
    _checkJobStatus();
  }

  // Check if the job has been assigned
  Future<void> _checkJobStatus() async {
    final String jobId = widget.jobId; // Use the jobId passed in the widget
    final String contractorUid = FirebaseAuth.instance.currentUser!.uid;

    final jobDoc = await FirebaseFirestore.instance
        .collection('jobAssignments')
        .where('jobId', isEqualTo: jobId)
        .where('contractorId', isEqualTo: contractorUid)
        .get();

    setState(() {
      if (jobDoc.docs.isNotEmpty) {
        isJobAssigned = true; // Job is already assigned to this contractor
      }
    });
  }

  // Launch phone dialer
  Future<void> _launchPhoneDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not dial the number: $phoneNumber')),
      );
    }
  }

  // Handle "Take Job" button press
  Future<void> _handleTakeJob() async {
    final String jobProviderUid =
        widget.job['uid'] ?? ''; // UID of the job provider
    final String contractorUid =
        FirebaseAuth.instance.currentUser!.uid; // UID of the current contractor
    final String jobId = widget.jobId;
    final jobAssignmentId =
        FirebaseFirestore.instance.collection('jobAssignments').doc().id;

    // Add job assignment to 'JobAssignments' collection
    await FirebaseFirestore.instance
        .collection('jobAssignments')
        .doc(jobAssignmentId)
        .set({
      'jobAssignmentId': jobAssignmentId,
      'jobId': jobId,
      'contractorId': contractorUid,
      'jobProviderUid': jobProviderUid,
      'status': 'assigned', // Job is assigned to this contractor
      'timestamp': FieldValue.serverTimestamp(),
      'jobType': widget.job['jobType'],
      'address': widget.job['address'],
      'district': widget.job['district'],
      'contact': widget.job['contactNumber'],
    });

    // Send a notification to the job provider
    await FirebaseFirestore.instance.collection('Notifications').add({
      'jobProviderUid': jobProviderUid,
      'contractorUid': contractorUid,
      'jobId': jobId,
      'message':
          'A contractor has accepted your job: ${widget.job['jobType']} at ${widget.job['address']}',
      'jobDetails': {
        'jobType': widget.job['jobType'],
        'address': widget.job['address'],
        'district': widget.job['district'],
        'contact': widget.job['contactNumber'],
      },
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'pending', // Job provider has not acted on the notification yet
    });

    setState(() {
      isJobAssigned = true; // Mark job as assigned in the UI
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job assigned to you successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    double widthFactor = MediaQuery.of(context).size.width;
    double heightFactor = MediaQuery.of(context).size.height;

    final List<dynamic> imageUrls = job['images'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          job['jobType'] ?? "Job Details",
          style:
              const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.green),
        elevation: 4,
      ),
      body: Column(
        children: [
          // Main content (Scrollable)
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(widthFactor * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Images Section (Carousel)
                  if (imageUrls.isNotEmpty)
                    CarouselSlider(
                      options: CarouselOptions(
                        height: heightFactor * 0.3,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: true,
                        autoPlayInterval: const Duration(seconds: 3),
                      ),
                      items: imageUrls.map((imageUrl) {
                        return GestureDetector(
                          onTap: () {
                            // Open zoomable image in full screen
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                child: Builder(
                                  builder: (context) {
                                    final imageWidth =
                                        MediaQuery.of(context).size.width;
                                    final imageHeight = imageWidth * 0.6;

                                    return SizedBox(
                                      width: imageWidth,
                                      height: imageHeight,
                                      child: PhotoViewGallery.builder(
                                        itemCount: imageUrls.length,
                                        builder: (context, index) {
                                          return PhotoViewGalleryPageOptions(
                                            imageProvider:
                                                NetworkImage(imageUrls[index]),
                                            minScale: PhotoViewComputedScale
                                                .contained,
                                            maxScale:
                                                PhotoViewComputedScale.covered,
                                          );
                                        },
                                        scrollPhysics:
                                            const BouncingScrollPhysics(),
                                        backgroundDecoration:
                                            const BoxDecoration(
                                                color: Colors.black),
                                        pageController: PageController(
                                            initialPage:
                                                imageUrls.indexOf(imageUrl)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(widthFactor * 0.05),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context)
                                  .size
                                  .width, // Full screen width
                              height: heightFactor * 0.25,
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    Center(
                      child: Text(
                        "No images available",
                        style: TextStyle(
                          fontSize: widthFactor * 0.045,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                  SizedBox(height: heightFactor * 0.03),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: widthFactor * 0.055,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: heightFactor * 0.015),
                  Text(
                    job['propertyDescription'] ?? "No description available",
                    style: TextStyle(
                      fontSize: widthFactor * 0.04,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: heightFactor * 0.03),

                  // Property Details
                  Text(
                    "Property Details",
                    style: TextStyle(
                      fontSize: widthFactor * 0.055,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: heightFactor * 0.015),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPropertyInfo("Type", job['propertyType']),
                      _buildPropertyInfo("Address", job['address']),
                      _buildPropertyInfo("Plot Size", job['plotSize']),
                      _buildPropertyInfo("Floors", job['floors']),
                      _buildPropertyInfo("Rooms", job['rooms']),
                      _buildPropertyInfo("Landmark", job['landmark']),
                    ],
                  ),
                  SizedBox(height: heightFactor * 0.04),
                ],
              ),
            ),
          ),

          // Bottom Buttons (fixed at the bottom)
          Container(
            padding: EdgeInsets.symmetric(
              vertical: heightFactor * 0.015,
              horizontal: widthFactor * 0.05,
            ),
            child: Row(
              children: [
                // Contact Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final contactNumber = job['contactNumber'] ?? "N/A";
                      if (contactNumber != "N/A") {
                        _launchPhoneDialer(contactNumber);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('No contact number available')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(vertical: heightFactor * 0.015),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    icon: const Icon(Icons.phone),
                    label: const Text("Contact Provider"),
                  ),
                ),
                SizedBox(width: widthFactor * 0.05),

                // Take Job Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isJobAssigned ? null : _handleTakeJob,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          isJobAssigned ? Colors.grey : Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(vertical: heightFactor * 0.015),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    icon: const Icon(Icons.assignment),
                    label: Text(isJobAssigned ? "Job Taken" : "Take Job"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyInfo(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        "$title: ${value ?? 'N/A'}",
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }
}
