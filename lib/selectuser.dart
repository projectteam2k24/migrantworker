import 'package:flutter/material.dart';
import 'package:migrantworker/contractor/screens/registration.dart';
import 'package:migrantworker/job_provider/screens/registration.dart';
import 'package:migrantworker/worker/screens/registration.dart';

class SelectUser extends StatefulWidget {
  const SelectUser({super.key});

  @override
  State<SelectUser> createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  @override
  Widget build(BuildContext context) {
    // Retrieve screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive padding and icon size
    final double horizontalPadding = screenWidth * 0.1;
    final double topPadding = screenHeight * 0.1;
    final double buttonIconSize = screenWidth * 0.15;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.person_2_outlined,
                  size: buttonIconSize,
                  color: Colors.green,
                ),
                label: const SizedBox.shrink(), // No label, only the icon is shown
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(buttonIconSize, buttonIconSize),
                  shape: const CircleBorder(), // Makes the button circular
                  padding: const EdgeInsets.all(24), // Padding around the icon
                  backgroundColor: Colors.green.shade100, // Change background color as needed
                  elevation: 5, // Elevation for raised appearance
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Text(
              'Welcome Guest',
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'I am here as :)',
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (screenWidth < 600) ? 2 : 3,
                  mainAxisSpacing: screenHeight * 0.02,
                  crossAxisSpacing: screenWidth * 0.05,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return buildGridItem(context, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridItem(BuildContext context, int index) {
    final icons = [
      Icons.construction,
      Icons.business_center,
      Icons.handyman,
    ];
    final titles = ["Worker", "Job Provider", "Contractor"];
    final routes = [const RegisterWorker(), const RegisterJobProvider(), const RegisterContractor()];

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => routes[index]));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icons[index], size: MediaQuery.of(context).size.width * 0.08, color: Colors.green),
            const SizedBox(height: 8),
            Text(
              titles[index],
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
