import 'package:flutter/material.dart';
import 'package:migrantworker/admin/contractorlist.dart';
import 'package:migrantworker/admin/jobproviderlist.dart';
import 'package:migrantworker/admin/viewreports.dart';
import 'package:migrantworker/admin/workerlist.dart';

void main() {
  runApp(const AdminModuleApp());
}

class AdminModuleApp extends StatelessWidget {
  const AdminModuleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green, // Green theme
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0xFFE8F5E9), // Light green background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green, // Green app bar background
          foregroundColor: Colors.white, // White text in the app bar
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.green, // Green bottom navigation bar
          selectedItemColor: Colors.white, // White selected icon color
          unselectedItemColor:
              Colors.white60, // Lighter white for unselected icons
        ),
      ),
      home: const AdminScreen(),
    );
  }
}

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    ViewReportScreen(), // Updated to use the imported ViewReportScreen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Module', style: TextStyle(fontSize: 24)),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, color: Colors.white),
            label: 'View Reports',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        backgroundColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildRoleCard(
            context,
            'Contractor',
            Icons.person, // Replaced with a person icon
            'Experienced in handling large projects',
            () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const ContractorListScreen();
                },
              ));
            },
          ),
          _buildRoleCard(
            context,
            'Worker',
            Icons.person, // Replaced with a person icon
            'Skilled in various labor tasks',
            () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const WorkerListScreen();
                },
              ));
            },
          ),
          _buildRoleCard(
            context,
            'Job Provider',
            Icons.person, // Replaced with a person icon
            'Connecting skilled workers with opportunities',
            () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const JobProviderListScreen();
                },
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
      BuildContext context, String title, IconData icon, String description,
      [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: Container(
          width: double.infinity,
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 80,
                color: Colors.green.shade700, // Icon color
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
