import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class JobDetailsPage extends StatefulWidget {
  final Map<String, dynamic> job;

  const JobDetailsPage({super.key, required this.job});

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  bool isFavorite = false;

  // Function to launch phone dialer
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

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    double widthFactor = MediaQuery.of(context).size.width;
    double heightFactor = MediaQuery.of(context).size.height;

    final List<dynamic> imageUrls = job['images'] ?? []; // Extract image URLs

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
                                          color: Colors.black,
                                        ),
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

                // Add to Favorite Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite
                                ? "Added to Favorites"
                                : "Removed from Favorites",
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orangeAccent,
                      padding:
                          EdgeInsets.symmetric(vertical: heightFactor * 0.015),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    label: Text(isFavorite ? "Favorited" : "Add to Favorites"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build property info
  Widget _buildPropertyInfo(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        "$label: ${value ?? 'N/A'}",
        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
      ),
    );
  }
}
