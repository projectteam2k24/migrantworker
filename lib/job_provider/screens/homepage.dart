import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:migrantworker/contractor/screens/contractordetailpage.dart';
import 'package:migrantworker/job_provider/screens/edit_profile.dart';
import 'package:migrantworker/job_provider/screens/myjob.dart';
import 'package:migrantworker/job_provider/screens/notification.dart';
import 'package:migrantworker/job_provider/screens/post_job.dart';
import 'package:migrantworker/job_provider/screens/profile.dart';
import 'package:migrantworker/job_provider/screens/search.dart';
import 'package:migrantworker/job_provider/screens/work_status.dart';
import 'package:migrantworker/login.dart';

class JobProviderHome extends StatefulWidget {
  const JobProviderHome({super.key});

  @override
  State<JobProviderHome> createState() => _JobProviderHomeState();
}

class _JobProviderHomeState extends State<JobProviderHome> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const ContractorSearch();
            },
          ),
        );
      } else if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const PostJobPage();
            },
          ),
        );
      } else if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const WorkingStatusPage();
            },
          ),
        );
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
          preferredSize:
              Size.fromHeight(heightFactor * 0.17), // Custom app bar height
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
                              return const JobProviderProfile();
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
          child: Padding(
            padding: EdgeInsets.all(widthFactor * 0.04),
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('Contractor').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No contractors available.'));
                }

                var contractorDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: contractorDocs.length,
                  itemBuilder: (context, index) {
                    var contractor =
                        contractorDocs[index].data() as Map<String, dynamic>;
                    String profileImageUrl = contractor['profilePicture'] ?? '';
                    String name = contractor['name'] ?? 'No Name';
                    String role = contractor['role'] ?? 'No Role';
                    String contact = contractor['phone'] ?? 'No Contact';
                    String email = contractor['email'] ?? 'No Email';

                    return GestureDetector(
                      onTap: () {
                        print(contractor['skill']);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ContractorAddetailPage(
                                contractorId: contractorDocs[index]
                                    .id, // Pass document ID
                                name: contractor['name'] ?? 'No Name',
                                jobType: contractor['role'] ?? 'No Role',
                                phone: contractor['phone'] ?? 'No Phone Number',
                                email: contractor['email'] ?? 'No Email',
                                companyName:
                                    contractor['companyName'] ?? 'No Company',
                                experience:
                                    contractor['experience'] ?? 'No Experience',
                                skills: contractor['skill'] ?? 'No Skill',
                                profilePictureUrl:
                                    contractor['profilePicture'],
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: heightFactor * 0.15,
                        margin: EdgeInsets.only(bottom: heightFactor * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.lightGreen[100],
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
                        child: Row(
                          children: [
                            // Left side: Profile image or default icon
                            Container(
                              width: widthFactor * 0.23,
                              height: heightFactor * 0.10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: profileImageUrl.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(profileImageUrl),
                                        fit: BoxFit.cover)
                                    : null,
                                color: Colors.grey[300],
                              ),
                              child: profileImageUrl.isEmpty
                                  ? Icon(Icons.person,
                                      size: widthFactor * 0.12,
                                      color: Colors.green)
                                  : null,
                            ),
                            SizedBox(width: widthFactor * 0.02),
                            // Right side: Contractor details
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                        fontSize: widthFactor * 0.05,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(role,
                                      style: TextStyle(
                                          fontSize: widthFactor * 0.04,
                                          color: Colors.grey)),
                                  Text(contact,
                                      style: TextStyle(
                                          fontSize: widthFactor * 0.04,
                                          color: Colors.grey)),
                                  Text(email,
                                      style: TextStyle(
                                          fontSize: widthFactor * 0.04,
                                          color: Colors.grey)),
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
              label: "Post Job",
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
                  return const PostJobPage();
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

/*class ContractorDetailPage extends StatelessWidget {
  final String contractorId;

  const ContractorDetailPage({super.key, required this.contractorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contractor Details')),
      body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('Contractor')
              .doc(contractorId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            var contractorData = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(contractorData['profileImage'] ?? ''),
                  child: contractorData['profileImage'] == null
                      ? Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                ),
                Text(contractorData['name'] ?? 'No Name'),
                Text(contractorData['role'] ?? 'No Role'),
                Text(contractorData['contact'] ?? 'No Contact'),
                Text(contractorData['email'] ?? 'No Email'),
              ],
            );
          },
        ),
      ),
    );
  }
}*/

class ProfileMenu extends StatefulWidget {
  final double widthFactor;

  const ProfileMenu({super.key, required this.widthFactor});

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  late String userName;

  @override
  void initState() {
    super.initState();
    userName = 'Loading...'; // Initial value for userName
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection(
                'Job Provider') // Replace with your Firestore collection name
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
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const LogIn();
                    },
                  ));
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
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const JobProviderProfile();
                        },
                      ));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.thumb_up),
                    title: const Text('My Jobs'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const MyJobPage();
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
                          return const JobProviderNotificationHub(
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
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const EditProfilePage();
                        },
                      ));
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const PostJobPage();
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              child: const Text('Post Job'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.green),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              child: const Text(
                'Working Status',
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
