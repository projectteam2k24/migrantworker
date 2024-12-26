import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:migrantworker/contractor/screens/job_details.dart';
import 'package:migrantworker/contractor/screens/homepage.dart'; // Adjust import path if necessary

class SearchJobPage extends StatefulWidget {
  const SearchJobPage({super.key});

  @override
  _SearchJobPageState createState() => _SearchJobPageState();
}

class _SearchJobPageState extends State<SearchJobPage> {
  String _selectedDateFilter = "Today";

  @override
  Widget build(BuildContext context) {
    double widthFactor = MediaQuery.of(context).size.width;
    double heightFactor = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Left arrow icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ContractorHome()), // Navigate to ContractorHome page
            );
          },
        ),
        title: Text(
          "Search Job",
          style: TextStyle(
            fontSize: widthFactor * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(widthFactor * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Type Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search the job type",
                      filled: true,
                      fillColor: Colors.green.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widthFactor * 0.03),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: widthFactor * 0.02),
                ElevatedButton(
                  onPressed: () {
                    // Add search functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(widthFactor * 0.03),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: heightFactor * 0.02),

            // Property Location Search Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Property Location",
                      filled: true,
                      fillColor: Colors.green.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widthFactor * 0.03),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: widthFactor * 0.02),
                ElevatedButton(
                  onPressed: () {
                    // Add search functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(widthFactor * 0.03),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: heightFactor * 0.03),

            // Filtering System with Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Posted Dates",
                  style: TextStyle(
                    fontSize: widthFactor * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: widthFactor * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(widthFactor * 0.03),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedDateFilter,
                    items: [
                      "Today",
                      "This Week",
                      "This Month",
                      "Last 3 Months",
                      "Last 6 Months"
                    ]
                        .map((date) => DropdownMenuItem<String>(
                              value: date,
                              child: Text(date),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDateFilter = newValue!;
                      });
                    },
                    underline: Container(),
                    dropdownColor: Colors.white, // Set dropdown color
                  ),
                ),
              ],
            ),
            SizedBox(height: heightFactor * 0.02),

            // Fetching and displaying job cards
            Expanded(
              child: JobCardList(),
            ),
          ],
        ),
      ),
    );
  }
}

class JobCardList extends StatelessWidget {
  const JobCardList({super.key});

  @override
  Widget build(BuildContext context) {
    double widthFactor = MediaQuery.of(context).size.width;
    double heightFactor = MediaQuery.of(context).size.height;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Jobs').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final jobs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index].data() as Map<String, dynamic>;
            final imageUrls = job['images'] ?? [];
             final jobId = jobs[index].id;

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return JobDetailsPage(job: job, jobId: jobId,);
                  },
                ));
              },
              child: Container(
                margin: EdgeInsets.only(bottom: heightFactor * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(widthFactor * 0.03),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Image Carousel
                    ClipRRect(
                      borderRadius: BorderRadius.circular(widthFactor * 0.03),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: heightFactor * 0.3,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                        ),
                        items: imageUrls.map<Widget>((imageUrl) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(widthFactor * 0.03),
                                topRight: Radius.circular(widthFactor * 0.03),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: heightFactor * 0.15,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(1.0),
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: heightFactor * 0.02,
                                  left: widthFactor * 0.04,
                                  right: widthFactor * 0.04,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        job['jobType'] ?? "Untitled Job",
                                        style: TextStyle(
                                          fontSize: widthFactor * 0.05,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: heightFactor * 0.005),
                                      Text(
                                        job['propertyDescription'] ??
                                            "No description available",
                                        style: TextStyle(
                                          fontSize: widthFactor * 0.04,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Location: ${job['district'] ?? 'Unknown'}",
                                            style: TextStyle(
                                              fontSize: widthFactor * 0.035,
                                              color: Colors.white.withOpacity(0.8),
                                            ),
                                          ),
                                          SizedBox(width: widthFactor * 0.02),
                                          Text(
                                            "Plot Size: ${job['plotSize']} sqft",
                                            style: TextStyle(
                                              fontSize: widthFactor * 0.035,
                                              color: Colors.white.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
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
