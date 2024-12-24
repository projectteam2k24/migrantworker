import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:migrantworker/chat_page.dart';
import 'package:migrantworker/worker/screens/chatscreen.dart';

class WorkerNotificationHub extends StatefulWidget {
  const WorkerNotificationHub({super.key, required this.toggle});

  final bool toggle;

  @override
  State<WorkerNotificationHub> createState() => _WorkerNotificationHubState();
}

class _WorkerNotificationHubState extends State<WorkerNotificationHub> {
  bool showMessages = true;
  String? workerId;
  List<Map<String, dynamic>> notifications = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    showMessages = widget.toggle;
    _fetchWorkerId();
  }

  Future<void> _fetchWorkerId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        workerId = user.uid;
      });
      await _fetchNotifications(workerId!);
    }
  }

  Future<void> _fetchNotifications(String workerId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('workerId', isEqualTo: workerId)
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        notifications = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      });
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    final dateFormat = DateFormat('dd-MM-yyyy hh:mm a');
    return dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Worker Notification Hub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
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
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: showMessages
                        ? WorkerChatScreen()
                        : _buildNotificationsList(),
                  ),
                ),
              ],
            ),
    );
  }

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
            : Timestamp.now();
        final notificationId = notification['id'];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
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
                  'From: ${notification['contractorName'] ?? 'Unknown'}',
                  style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                Text(
                  'Sent on: ${_formatTimestamp(timestamp)}',
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => _acceptRequest(notificationId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Accept'),
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: () => _rejectRequest(notificationId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Reject'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _acceptRequest(String notificationId) async {
    try {
      setState(() => loading = true);

      final notification = notifications.firstWhere((n) => n['id'] == notificationId);
      final String workerId = notification['workerId'];
      final String contractorId = notification['contractorId'];

      await FirebaseFirestore.instance.collection('notifications').doc(notificationId).update({'status': 'accepted'});
      await FirebaseFirestore.instance.collection('Worker').doc(workerId).update({'assigned': contractorId});
      await FirebaseFirestore.instance.collection('assignments').doc(workerId).set({
        'workerId': workerId,
        'contractorId': contractorId,
        'status': 'assigned',
        'timestamp': Timestamp.now(),
      });

      await FirebaseFirestore.instance.collection('notifications').doc(notificationId).delete();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request accepted.')));
      setState(() {
        notifications.removeWhere((n) => n['id'] == notificationId);
        loading = false;
      });
    } catch (e) {
      print("Error accepting request: $e");
      setState(() => loading = false);
    }
  }

  Future<void> _rejectRequest(String notificationId) async {
    try {
      setState(() => loading = true);

      final notification = notifications.firstWhere((n) => n['id'] == notificationId);

      await FirebaseFirestore.instance.collection('notifications').doc(notificationId).update({'status': 'rejected'});
      await FirebaseFirestore.instance.collection('assignments').doc(notification['workerId']).set({
        'workerId': notification['workerId'],
        'contractorId': notification['contractorId'],
        'status': 'rejected',
        'timestamp': Timestamp.now(),
      });

      await FirebaseFirestore.instance.collection('notifications').doc(notificationId).delete();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request rejected.')));
      setState(() {
        notifications.removeWhere((n) => n['id'] == notificationId);
        loading = false;
      });
    } catch (e) {
      print("Error rejecting request: $e");
      setState(() => loading = false);
    }
  }
}
