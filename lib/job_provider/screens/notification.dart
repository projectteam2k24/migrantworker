import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class JobProviderNotificationHub extends StatefulWidget {
  const JobProviderNotificationHub({super.key, required bool toggle});

  @override
  State<JobProviderNotificationHub> createState() =>
      _JobProviderNotificationHubState();
}

class _JobProviderNotificationHubState
    extends State<JobProviderNotificationHub> {
  bool showMessages = true; // Toggle between Messages and Notifications

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Job Provider Notification Hub',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green,
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
          ),
        );
      },
    );
  }

  // Fetch notifications dynamically from Firestore
  Widget _buildNotificationsList() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid; // Replace with actual user ID

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Notifications')
          .where('jobProviderUid', isEqualTo: currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No notifications available.'));
        }

        final notifications = snapshot.data!.docs;

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final contractorUid = notification['contractorUid'];
            final jobDetails = notification['jobDetails'];

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Contractor')
                  .doc(contractorUid)
                  .get(),
              builder: (context, contractorSnapshot) {
                if (contractorSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!contractorSnapshot.hasData ||
                    !contractorSnapshot.data!.exists) {
                  return const Center(
                      child: Text('Failed to load contractor details.'));
                }

                final contractorName =
                    contractorSnapshot.data!.get('name') ?? 'Unknown';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 2.0,
                  child: ListTile(
                    title: Text(
                      notification['message'] ?? 'Job Notification',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("From: $contractorName"),
                        Text(
                          "Job Type: ${jobDetails['jobType']}\n"
                          "Address: ${jobDetails['address']}\n"
                          "District: ${jobDetails['district']}\n"
                          "Contact: ${jobDetails['contact']}",
                        ),
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 8.0,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            // Accept Job
                            await FirebaseFirestore.instance
                                .collection('AssignedJobs')
                                .add({
                              'jobType': jobDetails['jobType'],
                              'address': jobDetails['address'],
                              'district': jobDetails['district'],
                              'contact': jobDetails['contact'],
                              'jobProviderUid': notification['jobProviderUid'],
                              'contractorUid': notification['contractorUid'],
                              'progress':0.0,
                              'timestamp': FieldValue.serverTimestamp(),
                            });

                            // Delete Notification
                            await FirebaseFirestore.instance
                                .collection('Notifications')
                                .doc(notification.id)
                                .delete();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Job accepted successfully.')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Accept'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // Reject Job (Delete Notification)
                            await FirebaseFirestore.instance
                                .collection('Notifications')
                                .doc(notification.id)
                                .delete();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Job rejected.')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Reject'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
