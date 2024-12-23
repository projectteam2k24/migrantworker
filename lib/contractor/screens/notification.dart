import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ChatScreen.dart'; // Import ChatScreen

class ContractorNotificationHub extends StatefulWidget {
  ContractorNotificationHub({super.key, required this.toggle});

  bool toggle;

  @override
  State<ContractorNotificationHub> createState() =>
      _ContractorNotificationHubState();
}

class _ContractorNotificationHubState extends State<ContractorNotificationHub> {
  bool showMessages = true; // Toggle between Messages and Notifications
  String? contractorId; // The contractor's ID (UID from Firebase Auth)
  List<Map<String, dynamic>> notifications = []; // Store notifications here
  List<Map<String, dynamic>> assignedWorkers =
      []; // List to store assigned workers

  @override
  void initState() {
    super.initState();
    showMessages = widget.toggle;
    _fetchContractorId();
  }

  // Fetch the contractorId (UID) from Firebase Authentication
  Future<void> _fetchContractorId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        contractorId = user.uid; // The UID of the logged-in contractor
      });
      _fetchAssignedWorkers(
          contractorId!); // Fetch assigned workers for this contractor
    }
  }

  // Fetch assigned workers for the specific contractor from Firestore
  Future<void> _fetchAssignedWorkers(String contractorId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .where('assigned',
              isEqualTo: contractorId) // Filter by assigned contractorId
          .get();

      setState(() {
        assignedWorkers = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id; // Include document ID
          return data;
        }).toList();
      });
    } catch (e) {
      print("Error fetching assigned workers: $e");
    }
  }

  // Format the timestamp to day-month-year and time in AM/PM
  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    final dateFormat =
        DateFormat('dd-MM-yyyy hh:mm a'); // Format: day-month-year, time AM/PM
    return dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contractor Notification Hub',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green, // Green palette for the app bar
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Toggle button
          Container(
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(8.0),
              isSelected: [showMessages, !showMessages],
              selectedColor: Colors.white,
              color: Colors.green[700],
              fillColor: Colors.green,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              borderWidth: 2,
              borderColor: Colors.green[300]!,
              selectedBorderColor: Colors.green,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text("Messages"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text("Notifications"),
                ),
              ],
              onPressed: (index) {
                setState(() {
                  showMessages = index == 0;
                });
              },
            ),
          ),

          // Display messages or notifications
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: showMessages
                  ? _buildMessagesList()
                  : _buildNotificationsList(),
            ),
          ),
        ],
      ),
    );
  }

  // Display assigned workers in Messages tab
  Widget _buildMessagesList() {
    if (assignedWorkers.isEmpty) {
      return const Center(
        child: Text(
          "No assigned workers.",
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: assignedWorkers.length,
      itemBuilder: (context, index) {
        final worker = assignedWorkers[index];
        final workerName = worker['name'] ?? 'Unknown Worker';
        final workerId = worker['id']; // Get workerId for navigation

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2.0,
          child: ListTile(
            leading: const Icon(Icons.person, color: Colors.green),
            title: Text(
              workerName,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              // Navigate to ChatScreen when tapping the worker's list tile
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    recipientId: workerId,
                    
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Display Notifications for the specific contractor
  Widget _buildNotificationsList() {
    if (notifications.isEmpty) {
      return const Center(
        child: Text(
          "No notifications available.",
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final timestamp = notification['timestamp'] is Timestamp
            ? notification['timestamp']
            : Timestamp.now(); // Fallback to current time if missing
        final notificationId = notification['id']; // Extracted document ID
        final workerId = notification['workerId']; // Worker ID from assignment

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('Worker')
              .doc(workerId) // Fetch the worker details using the workerId
              .get(),
          builder: (context, workerSnapshot) {
            if (workerSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!workerSnapshot.hasData || !workerSnapshot.data!.exists) {
              return const Center(child: Text("Worker data not found"));
            }

            final workerData =
                workerSnapshot.data!.data() as Map<String, dynamic>;
            final workerName = workerData['name'] ?? 'Unknown Worker';
            final status =
                notification['status']; // Assignment status (accepted/rejected)

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 2.0,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status == 'accepted'
                          ? 'Worker $workerName joined your team.'
                          : status == 'rejected'
                              ? 'Worker $workerName rejected the job request.'
                              : 'Status unknown for worker $workerName.',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Sent on: ${_formatTimestamp(timestamp)}',
                      style:
                          const TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
