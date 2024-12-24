import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:migrantworker/contractor/screens/job_details.dart';

import 'profile.dart';
import 'edit_profile.dart';
import 'notification.dart';
import 'worker_detail.dart';
import 'search_jobs.dart';
import 'worker_status.dart';
import 'worker_registration.dart';
import 'package:migrantworker/login.dart';

class ContractorHome extends StatefulWidget {
  const ContractorHome({super.key});

  @override
  State<ContractorHome> createState() => _ContractorHomeState();
}

class _ContractorHomeState extends State<ContractorHome> {
  int _selectedIndex = 0;
  String profilePictureUrl = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> assignedJobIds = [];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SearchJobPage()));
      } else if (_selectedIndex == 2) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const WorkerStatusPage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchProfilePicture();
    _fetchAssignedJobIds();
  }
  

  Future<void> _fetchProfilePicture() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('Contractor') // Replace with your collection name
            .doc(userId)
            .get();

        if (snapshot.exists) {
          final data = snapshot.data();
          print('Fetched data: $data'); // Debug log
          setState(() {
            profilePictureUrl = data?['profilePicture'] ?? '';
          });
        } else {
          print('No user data found');
          setState(() {
            profilePictureUrl = ''; // Default placeholder
          });
        }
      }
    } catch (e) {
      print('Error fetching profile picture: $e');
      setState(() {
        profilePictureUrl = ''; // Default placeholder
      });
    }
  }

  // Fetch the assigned job IDs from the AssignedJobs collection
  Future<void> _fetchAssignedJobIds() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('AssignedJobs').get();
      final assignedJobs = snapshot.docs;
      final List<String> jobIds = assignedJobs.map((doc) => doc.id).toList();
      setState(() {
        assignedJobIds = jobIds;
      });
    } catch (e) {
      print('Error fetching assigned job IDs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double widthFactor = MediaQuery.of(context).size.width;
    double heightFactor = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(heightFactor * 0.17),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: Padding(
              padding: EdgeInsets.only(
                top: heightFactor * 0.03,
                left: widthFactor * 0.04,
                right: widthFactor * 0.04,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Colors.green,
                            size: widthFactor * 0.12,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ),
                      Text(
                        "Migrant Connect",
                        style: TextStyle(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: widthFactor * 0.07,
                        ),
                      ),
                      IconButton(
                        icon: CircleAvatar(
                          backgroundImage: profilePictureUrl.isNotEmpty
                              ? NetworkImage(profilePictureUrl)
                              : const AssetImage('assets/placeer.png')
                                  as ImageProvider,
                          radius: 25,
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const ContractorProfile();
                            },
                          ));
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: heightFactor * 0.02),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.green),
                      hintText: "What are you looking for?",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widthFactor * 0.03),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        drawer: ProfileMenu(widthFactor: widthFactor),
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
                      return SizedBox.shrink();
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
                          borderRadius:
                              BorderRadius.circular(widthFactor * 0.03),
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
                                                job['jobType'] ??
                                                    "Untitled Job",
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
                                                      width:
                                                          widthFactor * 0.02),
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
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: Colors.green,
              ),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              label: "Add Worker",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              label: "Worker Status",
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class ProfileMenu extends StatefulWidget {
  final double widthFactor;
  const ProfileMenu({super.key, required this.widthFactor});

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  String userName = 'Loading...';
  String profilePictureUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _fetchProfilePicture();
  }

  Future<void> _fetchUserName() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection(
                'Contractor') // Replace with your Firestore collection name
            .doc(userId)
            .get();

        if (snapshot.exists) {
          setState(() {
            userName = snapshot.data()?['name'] ?? 'Unknown User';
          });
        } else {
          setState(() {
            userName = 'User Not Found';
          });
        }
      } else {
        setState(() {
          userName = 'Not Logged In';
        });
      }
    } catch (e) {
      setState(() {
        userName = 'Error Loading Name';
      });
      print('Error fetching user name: $e');
    }
  }

  Future<void> _fetchProfilePicture() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('Contractor') // Replace with your collection name
            .doc(userId)
            .get();

        if (snapshot.exists) {
          final data = snapshot.data();
          print('Fetched data: $data'); // Debug log
          setState(() {
            profilePictureUrl = data?['profilePicture'] ?? '';
          });
        } else {
          print('No user data found');
          setState(() {
            profilePictureUrl = ''; // Default placeholder
          });
        }
      }
    } catch (e) {
      print('Error fetching profile picture: $e');
      setState(() {
        profilePictureUrl = ''; // Default placeholder
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: widget.widthFactor * 0.8,
      child: Container(
        color: Colors.green.shade100,
        padding: EdgeInsets.symmetric(
          horizontal: widget.widthFactor * 0.05,
          vertical: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: profilePictureUrl.isNotEmpty
                    ? NetworkImage(profilePictureUrl)
                    : const AssetImage('assets/placeholder.png')
                        as ImageProvider, // Placeholder image
                radius: 55,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                userName,
                style: TextStyle(
                  fontSize: widget.widthFactor * 0.055,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LogIn(),
                      )); // Adjust route as necessary
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('My Account'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContractorProfile(),
                          )); // Adjust route as necessary
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.work),
                    title: const Text('Worker Details'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WorkerDetailsPage(),
                          )); // Adjust route as necessary
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.thumb_up),
                    title: const Text('Responses'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ContractorNotificationHub(
                            toggle: true,
                          );
                        },
                      ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notification Hub'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ContractorNotificationHub(
                            toggle: false,
                          );
                        },
                      ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit Profile'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditContractorProfile(),
                          )); // Adjust route as necessary
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchJobPage(),
                    )); // Adjust route as necessary
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              child: const Text('Search Job'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddExistingWorker(),
                    )); // Adjust route as necessary
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.green),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              child: const Text(
                'Add Worker',
                style: TextStyle(color: Colors.green),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'About\n~',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
