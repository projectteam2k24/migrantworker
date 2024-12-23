import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WorkerChatScreen extends StatefulWidget {
  // Recipient ID to identify the chat

  WorkerChatScreen();

  @override
  _WorkerChatScreenState createState() => _WorkerChatScreenState();
}

class _WorkerChatScreenState extends State<WorkerChatScreen> {
  TextEditingController _messageController = TextEditingController();
  late String currentUserId;
  late CollectionReference messagesCollection;

  bool loading = false;

  String? recipt;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    messagesCollection = FirebaseFirestore.instance.collection('chats');
    getWorkerData();
  }

  Future<Map<String, dynamic>?> getWorkerData() async {
    try {
      setState(() {
        loading = true;
      });
      // Fetch the document for the given contractor ID
      final documentSnapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .doc(FirebaseAuth
              .instance.currentUser?.uid) // Access the specific document
          .get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();

        recipt = data!['assigned'];
        return data as Map<String, dynamic>?; // Return the data as a Map
      } else {
        return null; // Return null if no document exists
      }
    } catch (e) {
      print("Error fetching worker data: $e");
      rethrow;

      // Re-throw the error for external handling
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // Send message to Firestore
  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await messagesCollection.add({
        'senderId': currentUserId,
        'recipientId': recipt,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  // Build the message list
  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: messagesCollection
          .where('recipientId', whereIn: [currentUserId, recipt]).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final senderId = message['senderId'];
            final text = message['message'];
            final timestamp = message['timestamp']?.toDate() ?? DateTime.now();

            return ListTile(
              title: Align(
                alignment: senderId == currentUserId
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: senderId == currentUserId
                        ? Colors.green
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                        color: senderId == currentUserId
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
              subtitle: Align(
                alignment: senderId == currentUserId
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
        backgroundColor: Colors.green,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // Message List
                Expanded(child: _buildMessageList()),

                // Message Input Area
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.green),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class WorkerListScreen extends StatefulWidget {
  @override
  _WorkerListScreenState createState() => _WorkerListScreenState();
}

class _WorkerListScreenState extends State<WorkerListScreen> {
  late String contractorId;
  late List<Map<String, dynamic>> assignedWorkers;

  @override
  void initState() {
    super.initState();
    contractorId = FirebaseAuth.instance.currentUser!.uid;
    assignedWorkers = [];
    _fetchAssignedWorkers();
  }

  // Fetch assigned workers for the contractor
  Future<void> _fetchAssignedWorkers() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .where('assigned', isEqualTo: contractorId)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assigned Workers'),
        backgroundColor: Colors.green,
      ),
      body: assignedWorkers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
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
                    title: Text(workerName),
                    onTap: () {
                      // Navigate to WorkerChatScreen and pass recipientId
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkerChatScreen(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
