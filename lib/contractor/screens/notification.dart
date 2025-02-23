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
  List<Map<String, dynamic>> requests = [];
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
      _fetchRequests(contractorId!);
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

  Future<void> _fetchRequests(String contractorId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('ContractorRequests')
          .where('contractorId', isEqualTo: contractorId)
          .get();

      setState(() {
        requests = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      });
    } catch (e) {
      print("Error fetching worker requests: $e");
    }
  }

  Future<void> _handleAcceptWorker(String workerId, String notificationId) async {
    try {
      await FirebaseFirestore.instance.collection('assignments').doc(workerId).update({
        'contractorId': contractorId,
      });

      await FirebaseFirestore.instance.collection('Worker').doc(workerId).update({
        'assigned': contractorId,
      });

      await FirebaseFirestore.instance.collection('ContractorRequests').doc(notificationId).delete();

      setState(() {
        requests.removeWhere((req) => req['id'] == notificationId);
      });
    } catch (e) {
      print("Error accepting worker: $e");
    }
  }

  Future<void> _handleRejectWorker(String notificationId) async {
    try {
      await FirebaseFirestore.instance.collection('ContractorRequests').doc(notificationId).delete();

      setState(() {
        requests.removeWhere((req) => req['id'] == notificationId);
      });
    } catch (e) {
      print("Error rejecting worker request: $e");
    }
  }

  Future<void> _handleRejectNotification(String notificationId) async {
    try {
      await FirebaseFirestore.instance.collection('contractorNoti').doc(notificationId).delete();

      setState(() {
        notifications.removeWhere((noti) => noti['id'] == notificationId);
      });
    } catch (e) {
      print("Error rejecting notification: $e");
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
              child: showMessages ? _buildMessagesList() : _buildNotificationsList(),
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
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
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
    return ListView(
      children: [
        _buildNotificationCategory("Worker Requests", requests, _handleAcceptWorker, _handleRejectWorker),
        _buildNotificationCategory("Notifications", notifications, null, _handleRejectNotification),
      ],
    );
  }

  Widget _buildNotificationCategory(String title, List<Map<String, dynamic>> items, Function(String, String)? onAccept, Function(String)? onReject) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...items.map((item) => Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 2.0,
              child: ListTile(
                title: Text(item['message'] ?? "Notification"),
                subtitle: Text('Sent on: ${_formatTimestamp(item['timestamp'] ?? Timestamp.now())}'),
                trailing: onAccept != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(onPressed: () => onAccept(item['workerId'], item['id']), child: const Text("Accept")),
                          const SizedBox(width: 8),
                          ElevatedButton(onPressed: () => onReject!(item['id']), child: const Text("Reject")),
                        ],
                      )
                    : null,
              ),
            )),
      ],
    );
  }
}
