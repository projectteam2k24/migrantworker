import 'package:flutter/material.dart';
import 'package:migrantworker/contractor/screens/profile.dart';
import 'package:migrantworker/contractor/screens/edit_profile.dart';
import 'package:migrantworker/contractor/screens/notification.dart';
import 'package:migrantworker/contractor/screens/worker_detail.dart';
import 'package:migrantworker/contractor/screens/search_jobs.dart';
import 'package:migrantworker/contractor/screens/worker_registration.dart';
import 'package:migrantworker/contractor/screens/worker_status.dart';
import 'package:migrantworker/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ContractorHome extends StatefulWidget {
  const ContractorHome({super.key});

  @override
  State<ContractorHome> createState() => _ContractorHomeState();
}

class _ContractorHomeState extends State<ContractorHome> {
  int _selectedIndex = 0;

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
                        icon: Icon(
                          Icons.account_circle,
                          color: Colors.green,
                          size: widthFactor * 0.15,
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
        body: SingleChildScrollView(
          child: Container(
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
                  child: Column(
                    children: List.generate(
                      jobs.length,
                      (index) {
                        final job = jobs[index].data() as Map<String, dynamic>;
                        final List<String> imageUrls = List<String>.from(job['images'] ?? []);

                        return Container(
                          height: heightFactor * 0.2,
                          margin: EdgeInsets.only(bottom: heightFactor * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.lightGreen[100],
                            borderRadius: BorderRadius.circular(widthFactor * 0.03),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Carousel Slider for Images
                              if (imageUrls.isNotEmpty)
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: heightFactor * 0.12,
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    enableInfiniteScroll: true,
                                  ),
                                  items: imageUrls.map<Widget>((imageUrl) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(widthFactor * 0.03),
                                          topRight: Radius.circular(widthFactor * 0.03),
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              Padding(
                                padding: EdgeInsets.all(widthFactor * 0.04),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            job['jobType'] ?? "Untitled Job",
                                            style: TextStyle(
                                              fontSize: widthFactor * 0.045,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: heightFactor * 0.01),
                                          Text(
                                            job['propertyDescription'] ?? "No description available",
                                            style: TextStyle(
                                              fontSize: widthFactor * 0.035,
                                              color: Colors.grey[700],
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) {
                                            return WorkerDetailsPage(); // Adjust route as necessary
                                          },
                                        ));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
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
                Icons.work,
                color: Colors.green,
              ),
              label: "Working Status",
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.lightGreen,
          onTap: _onItemTapped,
        ),
        floatingActionButton: SizedBox(
          height: widthFactor * 0.15,
          width: widthFactor * 0.15,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const WorkerDetailsPage();
                },
              ));
            },
            shape: const CircleBorder(),
            backgroundColor: Colors.lightGreen,
            child: Icon(
              Icons.add,
              size: widthFactor * 0.09,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('Contractor') // Replace with your Firestore collection name
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
                radius: widget.widthFactor * 0.13,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.person,
                  size: widget.widthFactor * 0.13,
                  color: Colors.white,
                ),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LogIn(),)); // Adjust route as necessary
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ContractorProfile(),)); // Adjust route as necessary
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.work),
                    title: const Text('Worker Details'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => WorkerDetailsPage(),)); // Adjust route as necessary
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditContractorProfile(),)); // Adjust route as necessary
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:(context) => SearchJobPage(),)); // Adjust route as necessary
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddExistingWorker(),)); // Adjust route as necessary
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
