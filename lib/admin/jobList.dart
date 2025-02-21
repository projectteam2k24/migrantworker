import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:migrantworker/contractor/screens/job_details.dart';

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double widthFactor = MediaQuery.of(context).size.width;
    final double heightFactor = MediaQuery.of(context).size.height;
    List<String> assignedJobIds = []; // This should be populated dynamically

    return Scaffold(
      appBar: AppBar(
        title: const Text("Jobs"),
      ),
      body: Container(
        color: Colors.white,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Jobs').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No jobs found"));
            }

            final jobs = snapshot.data!.docs;

            return Padding(
              padding: EdgeInsets.all(widthFactor * 0.04),
              child: ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index].data() as Map<String, dynamic>;
                  final jobId = jobs[index].id;

                  // Skip jobs that are already assigned
                  if (assignedJobIds.contains(jobId)) {
                    return const SizedBox.shrink();
                  }

                  final imageUrls = job['images'] ?? [];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return JobDetailsPage(
                            job: job,
                            jobId: jobId,
                          );
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
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(widthFactor * 0.03),
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
                                      topLeft:
                                          Radius.circular(widthFactor * 0.03),
                                      topRight:
                                          Radius.circular(widthFactor * 0.03),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                            SizedBox(
                                                height: heightFactor * 0.005),
                                            Text(
                                              job['propertyDescription'] ??
                                                  "No description available",
                                              style: TextStyle(
                                                fontSize: widthFactor * 0.04,
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Location: ${job['district'] ?? 'Unknown'}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        widthFactor * 0.035,
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: widthFactor * 0.02),
                                                Text(
                                                  "Plot Size: ${job['plotSize']} sqft",
                                                  style: TextStyle(
                                                    fontSize:
                                                        widthFactor * 0.035,
                                                    color: Colors.white
                                                        .withOpacity(0.8),
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
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                bool confirmDelete =
                                    await _confirmDelete(context);
                                if (confirmDelete) {
                                  await FirebaseFirestore.instance
                                      .collection('Jobs')
                                      .doc(jobId)
                                      .delete();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Delete Job"),
              content: const Text("Are you sure you want to delete this job?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child:
                      const Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
