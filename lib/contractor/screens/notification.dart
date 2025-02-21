import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:migrantworker/contractor/screens/chatscreen.dart';

// ignore: must_be_immutable
class ContractorNotificationHub extends StatefulWidget {
  ContractorNotificationHub({super.key, required this.toggle});

  bool toggle;

  @override
  State<ContractorNotificationHub> createState() =>
      _ContractorNotificationHubState();
}

class _ContractorNotificationHubState extends State<ContractorNotificationHub> {
  bool showMessages = true;
  String? contractorId;
  List<Map<String, dynamic>> notifications = [];
  List<Map<String, dynamic>> assignedWorkers = [];

  @override
  void initState() {
    super.initState();
    showMessages = widget.toggle;
    _fetchContractorId();
  }

  Future<void> _fetchContractorId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        contractorId = user.uid;
      });
      _fetchAssignedWorkers(contractorId!);
      _fetchNotifications(contractorId!);
    }
  }

  Future<void> _fetchAssignedWorkers(String contractorId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .where('assigned', isEqualTo: contractorId)
          .get();

      setState(() {
        assignedWorkers = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      });
    } catch (e) {
      print("Error fetching assigned workers: $e");
    }
  }

  Future<void> _fetchNotifications(String contractorId) async {
    try {
      // Fetching contractorNoti notifications
      final contractorNotiSnapshot = await FirebaseFirestore.instance
          .collection('contractorNoti')
          .where('contractorId', isEqualTo: contractorId)
          .get();

      // Fetching ContractorRequests notifications
      final contractorRequestsSnapshot = await FirebaseFirestore.instance
          .collection('ContractorRequests')
          .where('contractorId', isEqualTo: contractorId)
          .get();

      setState(() {
        notifications = [
          ...contractorNotiSnapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            data['source'] = 'contractorNoti';
            return data;
          }).toList(),
          ...contractorRequestsSnapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            data['source'] = 'ContractorRequests';
            return data;
          }).toList(),
        ];
      });
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }

  Future<void> _handleAccept(String workerId, String notificationId, String source) async {
    try {
      // Update assigned field in Worker collection
      await FirebaseFirestore.instance.collection('Worker').doc(workerId).update({
        'assigned': contractorId,
      });

      // Update contractorId in assignments collection
      await FirebaseFirestore.instance.collection('assignments').doc(workerId).update({
        'contractorId': contractorId,
      });

      // Delete the notification from the respective collection
      await FirebaseFirestore.instance.collection(source).doc(notificationId).delete();

      setState(() {
        notifications.removeWhere((noti) => noti['id'] == notificationId);
      });
    } catch (e) {
      print("Error accepting worker: $e");
    }
  }

  Future<void> _handleReject(String notificationId, String source) async {
    try {
      await FirebaseFirestore.instance.collection(source).doc(notificationId).delete();

      setState(() {
        notifications.removeWhere((noti) => noti['id'] == notificationId);
      });
    } catch (e) {
      print("Error rejecting worker: $e");
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
          'Contractor Notification Hub',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Column(
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
                  ? _buildMessagesList()
                  : _buildNotificationsList(),
            ),
          ),
        ],
      ),
    );
  }

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
        final workerId = worker['id'];

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(recipientId: workerId),
                ),
              );
            },
          ),
        );
      },
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
        final workerId = notification['workerId'];
        final notificationId = notification['id'];
        final source = notification['source'];
        final timestamp = notification['timestamp'] ?? Timestamp.now();

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2.0,
          child: ListTile(
            title: Text(
              'Worker Request',
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            subtitle: Text('Sent on: ${_formatTimestamp(timestamp)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => _handleAccept(workerId, notificationId, source),
                  child: const Text("Accept"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _handleReject(notificationId, source),
                  child: const Text("Reject"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
