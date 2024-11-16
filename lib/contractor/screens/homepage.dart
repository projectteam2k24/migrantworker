import 'package:flutter/material.dart';
import 'package:migrantworker/contractor/screens/profile.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(129.0), // Custom appbar height
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: Padding(
              padding:
                  const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
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
                            size: 50.0,
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
                          fontSize: 26.0,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.account_circle,
                          color: Colors.green,
                          size: 60.0,
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ContractorProfile();
                            },
                          ));
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search,
                          color: Colors.green), //add controller
                      hintText: "What are you looking for?",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        drawer: ProfileMenu(), // Add the ProfileMenu here
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: 10, // Number of cards
            itemBuilder: (context, index) {
              return Container(
                height: 120.0, // Card height
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: Colors.lightGreen[100],
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category,
                      size: 50.0,
                      color: Colors.green,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      "Card ${index + 1}",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: Colors.green,
                size: 40.0,
              ),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 30.0,
              ),
              label: "Add Worker",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.work,
                color: Colors.green,
                size: 35.0,
              ),
              label: "Working Status",
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.lightGreen,
          onTap: _onItemTapped,
        ),
        floatingActionButton: SizedBox(
          height: 70, // Adjust height
          width: 70, // Adjust width
          child: FloatingActionButton(
            onPressed: () {
              // Handle action here
            },
            child: Icon(Icons.add, size: 36, color: Colors.white,), // Increased icon size
            shape: CircleBorder(),
            backgroundColor: Colors.lightGreen, // Optional: Change color if needed
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Container(
        color: Colors.green.shade100,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Jais Roy',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: GestureDetector(
                onTap: () {
                  // Handle Sign Out logic
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('My Account'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContractorProfile(),
                          ));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.work),
                    title: Text('Worker Details'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to Contact Views
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.thumb_up),
                    title: Text('Responses'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to Responses
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Notification Hub'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to Notification Hub
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit Profile'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle Post Property
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
              child: Text('Search Job'),
            ),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                // Handle Post Requirement
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.green),
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
              child: Text(
                'Add Worker',
                style: TextStyle(color: Colors.green),
              ),
            ),
            SizedBox(height: 20),
            Center(
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
