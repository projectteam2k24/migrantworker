import 'package:flutter/material.dart';
import 'package:migrantworker/chat_page.dart';

// ignore: must_be_immutable
class WorkerNotificationHub extends StatefulWidget {
  WorkerNotificationHub({super.key, required this.toggle});

  bool toggle;

  @override
  State<WorkerNotificationHub> createState() => _WorkerNotificationHubState();
}

class _WorkerNotificationHubState extends State<WorkerNotificationHub> {
  bool showMessages = true; // Toggle between Messages and Notifications

  @override
  void initState() {
    super.initState();
    showMessages = widget.toggle;
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
      // Floating Action Button only for Messages
      floatingActionButton: showMessages
          ? FloatingActionButton(
              onPressed: () {
                // Navigate to a new message creation page (or relevant action)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navigate to New Message Page!')),
                );
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.chat),
            )
          : null,
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
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
            },
          ),
        );
      },
    );
  }

  // Dummy list for Notifications
  Widget _buildNotificationsList() {
    final notifications = [
      'Worker X joined your team.',
      'Job Provider Y posted a new job.',
      'Reminder: Complete the pending job report.',
    ];

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2.0,
          child: ListTile(
            leading: const Icon(Icons.notifications, color: Colors.green),
            title: Text(
              notifications[index],
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
          ),
        );
      },
    );
  }
}
