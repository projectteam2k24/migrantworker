import 'package:flutter/material.dart';

class WorkingStatusPage extends StatelessWidget {
  const WorkingStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample job data
    final List<Map<String, dynamic>> jobList = [
      {
        'jobTitle': 'Painting - Residential',
        'contractorName': 'John Doe Constructions',
        'startDate': '01/11/2024',
        'endDate': '10/11/2024',
        'status': 'In Progress',
        'progress': 1.0,
      },
      {
        'jobTitle': 'Electrical Wiring',
        'contractorName': 'Elite Electricians',
        'startDate': '05/11/2024',
        'endDate': '20/11/2024',
        'status': 'Completed',
        'progress': 1.0,
      },
      {
        'jobTitle': 'Flooring Installation',
        'contractorName': 'Modern Builders',
        'startDate': '10/11/2024',
        'endDate': '25/11/2024',
        'status': 'Not Started',
        'progress': 0.0,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Working Status'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green, width: 1.5),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by Job Title...',
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Add search logic here
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Job Cards
            Expanded(
              child: ListView.builder(
                itemCount: jobList.length,
                itemBuilder: (context, index) {
                  final job = jobList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job['jobTitle'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.business,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Contractor: ${job['contractorName']}',
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                'Start: ${job['startDate']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'End: ${job['endDate']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.info,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                'Status: ${job['progress'] == 0 ? 'Not Started' : job['progress'] == 1.0 ? 'Completed' : 'In Progress'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: job['progress'] >= 0.85
                                      ? Colors.green
                                      : job['progress'] >= 0.25
                                          ? Colors.orange
                                          : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          LinearProgressIndicator(
                            value: job['progress'],
                            backgroundColor: Colors.grey[300],
                            color: job['progress'] >= 0.85
                                ? Colors.green
                                : job['progress'] >= 0.25
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${(job['progress'] * 100).toInt()}% Completed',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
