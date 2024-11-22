import 'package:flutter/material.dart';

class ContractorNotifications extends StatefulWidget {
  const ContractorNotifications({super.key});

  @override
  State<ContractorNotifications> createState() => _ContractorNotificationsState();
}

class _ContractorNotificationsState extends State<ContractorNotifications> {
  // Sample list of notifications
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Job Assigned',
      'description': 'You have been assigned a new job at Site A.',
      'icon': Icons.work,
      'timestamp': '2 hours ago',
      'isRead': false,
    },
    {
      'title': 'Worker Request',
      'description': 'Worker John Smith has requested to join your team.',
      'icon': Icons.person_add,
      'timestamp': '5 hours ago',
      'isRead': false,
    },
    {
      'title': 'Payment Received',
      'description': 'Payment for Job #1234 has been received.',
      'icon': Icons.attach_money,
      'timestamp': '1 day ago',
      'isRead': true,
    },
    {
      'title': 'Job Completion Reminder',
      'description': 'Job #5678 is due for completion tomorrow.',
      'icon': Icons.calendar_today,
      'timestamp': '2 days ago',
      'isRead': true,
    },
    {
      'title': 'Worker Removed',
      'description': 'Worker Jane Doe has been removed from your team.',
      'icon': Icons.remove_circle,
      'timestamp': '3 days ago',
      'isRead': true,
    },
  ];

  // Method to mark all notifications as read
  void markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['isRead'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contractor Notifications',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            IconButton(
              icon: const Icon(Icons.mark_email_read),
              onPressed: markAllAsRead,
              tooltip: 'Mark all as read',
            ),
          ],
        ),
        body: notifications.isEmpty
            ? const Center(
                child: Text(
                  'No Notifications',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return ListTile(
                    leading: Icon(
                      notification['icon'],
                      color: notification['isRead'] ? Colors.grey : Colors.blue,
                    ),
                    title: Text(
                      notification['title'],
                      style: TextStyle(
                        fontWeight: notification['isRead']
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(notification['description']),
                    trailing: Text(
                      notification['timestamp'],
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      // Handle notification click, e.g., navigate to details
                      setState(() {
                        notification['isRead'] = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${notification['title']} tapped'),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
