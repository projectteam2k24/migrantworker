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
  List<Map<String, dynamic>> assignedWorkers = [];
  List<Map<String, dynamic>> notifications = [];

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

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd-MM-yyyy hh:mm a').format(dateTime);
  }

  Future<void> _updateRequestStatus(String workerId, String status) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('ContractorRequests')
          .where('workerId', isEqualTo: workerId)
          .where('contractorId', isEqualTo: contractorId)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'status': status});
      }
    } catch (e) {
      print("Error updating request status: $e");
    }
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
              child: showMessages ? _buildMessagesList() : _buildNotificationsList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    if (assignedWorkers.isEmpty) {
      return const Center(child: Text("No assigned workers.", style: TextStyle(fontSize: 18)));
    }

    return ListView.builder(
      itemCount: assignedWorkers.length,
      itemBuilder: (context, index) {
        final worker = assignedWorkers[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2.0,
          child: ListTile(
            leading: const Icon(Icons.person, color: Colors.green),
            title: Text(worker['name'] ?? 'Unknown Worker',
                style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(recipientId: worker['id']),
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
      return const Center(child: Text("No notifications available.", style: TextStyle(fontSize: 18)));
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 2.0,
          child: ListTile(
            title: Text(notification['message'] ?? 'No message'),
            subtitle: Text('Sent on: ${_formatTimestamp(notification['timestamp'])}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => _updateRequestStatus(notification['workerId'], 'approved'),
                  child: const Text("Accept", style: TextStyle(color: Colors.green)),
                ),
                TextButton(
                  onPressed: () => _updateRequestStatus(notification['workerId'], 'rejected'),
                  child: const Text("Reject", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
