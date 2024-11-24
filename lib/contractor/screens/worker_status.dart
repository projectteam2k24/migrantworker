import 'package:flutter/material.dart';
import 'package:migrantworker/contractor/screens/homepage.dart';


class WorkerStatusPage extends StatefulWidget {
  const WorkerStatusPage({super.key});

  @override
  State<WorkerStatusPage> createState() => _WorkerStatusPageState();
}

class _WorkerStatusPageState extends State<WorkerStatusPage> {
  // Sample worker data
  List<Map<String, dynamic>> workers = [
    {
      "name": "John Doe",
      "job": "Masonry Work",
      "status": "Working",
      "statusOptions": ["Working", "On Leave", "Idle"]
    },
    {
      "name": "Jane Smith",
      "job": "Painting",
      "status": "On Leave",
      "statusOptions": ["Working", "On Leave", "Idle"]
    },
    {
      "name": "Alan Walker",
      "job": "Electrician",
      "status": "Idle",
      "statusOptions": ["Working", "On Leave", "Idle"]
    },
  ];

  @override
  Widget build(BuildContext context) {
    double widthFactor = MediaQuery.of(context).size.width;
    double heightFactor = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const ContractorHome();
            },));  
          },
        ),
        title: const Text(
          "Worker Status",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        elevation: 6,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(widthFactor * 0.04),
        child: ListView.builder(
          itemCount: workers.length,
          itemBuilder: (context, index) {
            final worker = workers[index];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              margin: EdgeInsets.only(bottom: heightFactor * 0.02),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(widthFactor * 0.04),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  // Handle tap to show details or edit worker status
                  print("Tapped on worker: ${worker['name']}");
                },
                child: Container(
                  padding: EdgeInsets.all(widthFactor * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        worker['name'],
                        style: TextStyle(
                          fontSize: widthFactor * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                      ),
                      SizedBox(height: heightFactor * 0.01),
                      Text(
                        "Current Job: ${worker['job']}",
                        style: TextStyle(
                          fontSize: widthFactor * 0.045,
                          color: Colors.green[800],
                        ),
                      ),
                      SizedBox(height: heightFactor * 0.015),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status:",
                            style: TextStyle(
                              fontSize: widthFactor * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DropdownButton<String>(
                            value: worker['status'],
                            items: worker['statusOptions']
                                .map<DropdownMenuItem<String>>((String status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newStatus) {
                              setState(() {
                                worker['status'] = newStatus!;
                              });
                            },
                            icon: const Icon(Icons.arrow_drop_down),
                            style: TextStyle(
                              fontSize: widthFactor * 0.045,
                              color: Colors.green[900],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: heightFactor * 0.015),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Status Change"),
                                content: Text(
                                    "Are you sure you want to change the status of ${worker['name']} to '${worker['status']}'?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Add logic to save changes if needed
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Confirm"),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                              vertical: heightFactor * 0.012,
                              horizontal: widthFactor * 0.05,
                            ),
                          ),
                          icon: const Icon(Icons.sync_alt),
                          label: const Text("Update Status"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}