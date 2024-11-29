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
      "status": "Not Started",
      "progress": 0.0,
    },
    {
      "name": "Jane Smith",
      "job": "Painting",
      "status": "In Progress",
      "progress": 50.0,
    },
    {
      "name": "Alan Walker",
      "job": "Electrician",
      "status": "Completed",
      "progress": 100.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    double widthFactor = MediaQuery.of(context).size.width;
    double heightFactor = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const ContractorHome();
              },
            ));
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
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
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
                          Text(
                            worker['status'],
                            style: TextStyle(
                              fontSize: widthFactor * 0.045,
                              color: worker['status'] == "Completed"
                                  ? Colors.green[700]
                                  : (worker['status'] == "In Progress"
                                      ? Colors.orange[700]
                                      : Colors.red[700]),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: heightFactor * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Completion:",
                            style: TextStyle(
                              fontSize: widthFactor * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${worker['progress'].toInt()}%",
                            style: TextStyle(
                              fontSize: widthFactor * 0.045,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: worker['progress'],
                        min: 0.0,
                        max: 100.0,
                        divisions: 100,
                        activeColor: Colors.green,
                        inactiveColor: Colors.green.withOpacity(0.3),
                        label: "${worker['progress'].toInt()}%",
                        onChanged: (double newValue) {
                          setState(() {
                            worker['progress'] = newValue;
                            if (newValue == 100.0) {
                              worker['status'] = "Completed";
                            } else if (newValue > 0.0) {
                              worker['status'] = "In Progress";
                            } else {
                              worker['status'] = "Not Started";
                            }
                          });
                        },
                      ),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Update Completion"),
                                content: Text(
                                    "Are you sure you want to update the progress of ${worker['name']} to ${worker['progress'].toInt()}%?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Progress for ${worker['name']} updated to ${worker['progress'].toInt()}%"),
                                        ),
                                      );
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
                          label: const Text("Save Progress"),
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
