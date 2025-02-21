import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:migrantworker/contractor/screens/job_details.dart';
import 'package:migrantworker/contractor/screens/homepage.dart';

class SearchJobPage extends StatefulWidget {
  const SearchJobPage({super.key});

  @override
  _SearchJobPageState createState() => _SearchJobPageState();
}

class _SearchJobPageState extends State<SearchJobPage> {
  String _selectedDateFilter = "Today";
  String jobTypeQuery = "";
  String locationQuery = "";

  @override
  Widget build(BuildContext context) {
    double widthFactor = MediaQuery.of(context).size.width;
    double heightFactor = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ContractorHome()),
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
                      hintText: "Search Job Type",
                      filled: true,
                      fillColor: Colors.green.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widthFactor * 0.03),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        jobTypeQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                SizedBox(width: widthFactor * 0.02),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(widthFactor * 0.03),
                  ),
                  child: const Icon(Icons.search, color: Colors.white),
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
                    onChanged: (value) {
                      setState(() {
                        locationQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
                SizedBox(width: widthFactor * 0.02),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(widthFactor * 0.03),
                  ),
                  child: const Icon(Icons.search, color: Colors.white),
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
                ),
              ],
            ),
            SizedBox(height: heightFactor * 0.02),

            // Job Card List with Search Filters
            Expanded(
              child: JobCardList(
                jobTypeQuery: jobTypeQuery,
                locationQuery: locationQuery,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Job Listing Component with Filters
class JobCardList extends StatelessWidget {
  final String jobTypeQuery;
  final String locationQuery;

  const JobCardList(
      {super.key, required this.jobTypeQuery, required this.locationQuery});

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

        final jobs = snapshot.data!.docs.where((doc) {
          final job = doc.data() as Map<String, dynamic>;
          final jobType = (job['jobType'] ?? "").toString().toLowerCase();
          final location = (job['town'] ?? "").toString().toLowerCase();

          return jobType.contains(jobTypeQuery) &&
              location.contains(locationQuery);
        }).toList();

        if (jobs.isEmpty) {
          return const Center(child: Text("No matching jobs found"));
        }

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
                    return JobDetailsPage(job: job, jobId: jobId);
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widthFactor * 0.03),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: heightFactor * 0.3,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1.0,
                    ),
                    items: imageUrls.map<Widget>((imageUrl) {
                      return Image.network(imageUrl, fit: BoxFit.cover);
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
