import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:migrantworker/chat_page.dart';

class WorkerNotificationHub extends StatefulWidget {
  WorkerNotificationHub({super.key, required this.toggle});

  bool toggle;

  @override
  State<WorkerNotificationHub> createState() => _WorkerNotificationHubState();
}

class _WorkerNotificationHubState extends State<WorkerNotificationHub> {
  bool showMessages = true; // Toggle between Messages and Notifications
  String? workerId; // The worker's ID (UID from Firebase Auth)
  List<Map<String, dynamic>> notifications = []; // Store notifications here

  @override
  void initState() {
    super.initState();
    showMessages = widget.toggle;
    _fetchWorkerId();
  }

  // Fetch the workerId (UID) from Firebase Authentication
  Future<void> _fetchWorkerId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        workerId = user.uid; // The UID of the logged-in user
      });
      _fetchNotifications(workerId!); // Fetch notifications for this worker
    }
  }

  // Fetch notifications for the specific worker from Firestore
  Future<void> _fetchNotifications(String workerId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('workerId', isEqualTo: workerId) // Filter by workerId
          .orderBy('timestamp', descending: true) // Order by timestamp
          .get();

      setState(() {
        notifications = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id; // Include document ID
          return data;
        }).toList();
      });
    } catch (e) {
      print("Error fetching notifications: $e");
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
          'Worker Notification Hub',
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

  // Dummy list for Messages
  Widget _buildMessagesList() {
    final messages = [
      'Chat with John: "Can we discuss the job tomorrow?"',
      'Chat with Alice: "I have completed the assigned task."',
      'Chat with Mark: "Please send me the details."',
    ];

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2.0,
          child: ListTile(
            leading: const Icon(Icons.chat, color: Colors.green),
            title: Text(
              messages[index],
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              // Navigate to ChatPage when tapping on a message
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatPage()),
              );
            },
          ),
        );
      },
    );
  }

  // Display Notifications for the specific worker
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

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2.0,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification['message'] ?? 'No message content',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'From: ${notification['workerName'] ?? 'Unknown'}',
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                    Text(
                      'Sent on: ${_formatTimestamp(timestamp)}',
                      style:
                          const TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(30.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30.0),
                      onTap: () async {
                        await _acceptRequest(notificationId);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          gradient: LinearGradient(
                            colors: [Colors.green, Colors.lightGreen],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20.0,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              'Accept',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Accept the request
  Future<void> _acceptRequest(String notificationId) async {
    try {
      // Fetch notification data
      final notification =
          notifications.firstWhere((n) => n['id'] == notificationId);
      final String workerId = notification['workerId'];
      final String contractorId = notification['contractorId'];

      // Update the notification status in Firestore
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .update({'status': 'accepted'});

      // Update the worker's "assigned" field with the contractorId
      await FirebaseFirestore.instance
          .collection('Worker')
          .doc(workerId)
          .update({'assigned': contractorId});

      // Notify success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Request accepted. Worker assigned to contractor.')),
      );

      // Refresh notifications
      if (workerId != null) {
        await _fetchNotifications(workerId!);
      }
    } catch (e) {
      print("Error accepting request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to accept the request.')),
      );
    }
  }
}
