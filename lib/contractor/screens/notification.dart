import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      _fetchContractorRequests(contractorId!);
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
      final snapshot = await FirebaseFirestore.instance
          .collection('contractorNoti')
          .where('contractorId', isEqualTo: contractorId)
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

  Future<void> _fetchContractorRequests(String contractorId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('ContractorRequests')
          .where('contractorId', isEqualTo: contractorId)
          .get();

      setState(() {
        notifications.addAll(snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          data['type'] = 'request'; // Mark it as a request type
          return data;
        }).toList());
      });
    } catch (e) {
      print("Error fetching contractor requests: $e");
    }
  }

  Future<void> _handleAccept(String workerId, String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Worker')
          .doc(workerId)
          .update({
        'assigned': contractorId,
      });

      await FirebaseFirestore.instance
          .collection('assignments')
          .doc(workerId)
          .update({
        'contractorId': contractorId,
      });

      await FirebaseFirestore.instance
          .collection('ContractorRequests')
          .doc(notificationId)
          .delete();

      setState(() {
        notifications.removeWhere((noti) => noti['id'] == notificationId);
      });
    } catch (e) {
      print("Error accepting worker: $e");
    }
  }

  Future<void> _handleReject(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('ContractorRequests')
          .doc(notificationId)
          .delete();

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

  Widget _buildNotificationsList() {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final String message = notification['message'] ?? 'No message';
        final String time = _formatTimestamp(notification['timestamp']);
        final String type = notification['type'] ?? 'notification';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(message,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(time),
            trailing: type == 'request'
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => _handleAccept(
                            notification['workerId'], notification['id']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _handleReject(notification['id']),
                      ),
                    ],
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildMessagesList() {
    return Center(
      child: Text(
        "No messages available",
        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
      ),
    );
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
}
