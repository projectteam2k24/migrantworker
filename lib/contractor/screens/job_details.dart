import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class JobDetailsPage extends StatefulWidget {
  final Map<String, dynamic> job;

  const JobDetailsPage({Key? key, required this.job}) : super(key: key);

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  bool isFavorite = false;

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
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.green),
        elevation: 1,
      ),
      body: SingleChildScrollView(
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
                  enlargeCenterPage: false,
                  viewportFraction: 1.0, // Ensures the image takes full width
                ),
                items: imageUrls.map((imageUrl) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(widthFactor * 0.03),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width, // Full screen width
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

            SizedBox(height: heightFactor * 0.02),
            Text(
              "Description",
              style: TextStyle(
                fontSize: widthFactor * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: heightFactor * 0.01),
            Text(
              job['propertyDescription'] ?? "No description available",
              style: TextStyle(
                fontSize: widthFactor * 0.04,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: heightFactor * 0.02),

            // Property Details
            Text(
              "Property Details",
              style: TextStyle(
                fontSize: widthFactor * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: heightFactor * 0.01),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Type: ${job['propertyType'] ?? 'N/A'}",
                  style: TextStyle(fontSize: widthFactor * 0.04, color: Colors.grey[800]),
                ),
                SizedBox(height: heightFactor * 0.005),
                Text(
                  "Address: ${job['address'] ?? 'N/A'}",
                  style: TextStyle(fontSize: widthFactor * 0.04, color: Colors.grey[800]),
                ),
                SizedBox(height: heightFactor * 0.005),
                Text(
                  "Plot Size: ${job['plotSize'] ?? 'N/A'} sqft",
                  style: TextStyle(fontSize: widthFactor * 0.04, color: Colors.grey[800]),
                ),
                SizedBox(height: heightFactor * 0.005),
                Text(
                  "Floors: ${job['floors'] ?? 'N/A'}",
                  style: TextStyle(fontSize: widthFactor * 0.04, color: Colors.grey[800]),
                ),
                SizedBox(height: heightFactor * 0.005),
                Text(
                  "Rooms: ${job['rooms'] ?? 'N/A'}",
                  style: TextStyle(fontSize: widthFactor * 0.04, color: Colors.grey[800]),
                ),
                SizedBox(height: heightFactor * 0.005),
                Text(
                  "Landmark: ${job['landmark'] ?? 'N/A'}",
                  style: TextStyle(fontSize: widthFactor * 0.04, color: Colors.grey[800]),
                ),
              ],
            ),
            SizedBox(height: heightFactor * 0.03),

            // Contact and Favorite Buttons
            Row(
              children: [
                // Contact Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add contact logic here (e.g., opening dialer)
                      final contactNumber = job['contactNumber'] ?? "N/A";
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Contact Number: $contactNumber"),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: heightFactor * 0.015),
                    ),
                    icon: const Icon(Icons.phone, color: Colors.white),
                    label: const Text(
                      "Contact Provider",
                      style: TextStyle(color: Colors.white),
                    ),
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
                      backgroundColor: Colors.lightGreen,
                      padding: EdgeInsets.symmetric(vertical: heightFactor * 0.015),
                    ),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    label: Text(
                      isFavorite ? "Favorited" : "Add to Favorites",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
