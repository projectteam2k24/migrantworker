import 'package:flutter/material.dart';

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
        child: ListView(
          children: [
            // Search Bar Section
            Column(
              children: [
                // Job Type Search Bar
                TextField(
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
                SizedBox(height: heightFactor * 0.02),

                // Property Location Search Bar
                TextField(
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
                      width: widthFactor * 0.4,
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
                        isExpanded: true,
                        underline: Container(),
                        dropdownColor: Colors.green.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightFactor * 0.03),

                // "Top Jobs" section
                Text(
                  "Top Jobs",
                  style: TextStyle(
                    fontSize: widthFactor * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: heightFactor * 0.02),

                // Job Cards
                JobCard(
                  jobTitle: "Painter Needed",
                  jobDetails: "Location: Downtown, 3 Bedrooms",
                  jobDate: "Posted 2 days ago",
                ),
                JobCard(
                  jobTitle: "Plumber Required",
                  jobDetails: "Location: Uptown, 1 Bathroom",
                  jobDate: "Posted 1 week ago",
                ),
                JobCard(
                  jobTitle: "Electrician Service",
                  jobDetails: "Location: Suburb, Electrical Wiring",
                  jobDate: "Posted 1 month ago",
                ),
                JobCard(
                  jobTitle: "Carpenter Required",
                  jobDetails: "Location: Central, 5 Doors",
                  jobDate: "Posted 3 months ago",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final String jobTitle;
  final String jobDetails;
  final String jobDate;

  const JobCard({
    required this.jobTitle,
    required this.jobDetails,
    required this.jobDate,
  });

  @override
  Widget build(BuildContext context) {
    double widthFactor = MediaQuery.of(context).size.width;
    double heightFactor = MediaQuery.of(context).size.height;

    return Card(
      margin: EdgeInsets.only(bottom: heightFactor * 0.02),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widthFactor * 0.03),
      ),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(widthFactor * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jobTitle,
              style: TextStyle(
                fontSize: widthFactor * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: heightFactor * 0.01),
            Text(
              jobDetails,
              style: TextStyle(
                fontSize: widthFactor * 0.04,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: heightFactor * 0.01),
            Text(
              jobDate,
              style: TextStyle(
                fontSize: widthFactor * 0.03,
                color: Colors.green.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
