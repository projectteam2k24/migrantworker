import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String recipientId; // Recipient ID to identify the chat

  const ChatScreen({super.key, required this.recipientId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late String currentUserId;
  late CollectionReference messagesCollection;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Get the current user's ID
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    // Reference to the 'chats' collection
    messagesCollection = FirebaseFirestore.instance.collection('chats');
  }

  // Send message to Firestore
  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await messagesCollection.add({
        'senderId': currentUserId,
        'recipientId': widget.recipientId,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
      _scrollToBottom(); // Scroll to the latest message
    }
  }

  // Scroll to the latest message
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Build the message list
  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: messagesCollection
          .orderBy('timestamp', descending: true) // Order messages by timestamp
          .where('recipientId',
              whereIn: [currentUserId, widget.recipientId]).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!.docs;

        return ListView.builder(
          controller: _scrollController,
          reverse: true, // Reverse for WhatsApp-style ordering
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final senderId = message['senderId'];
            final text = message['message'];
            final timestamp = message['timestamp']?.toDate() ?? DateTime.now();

            final isSentByCurrentUser = senderId == currentUserId;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Align(
                alignment: isSentByCurrentUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: isSentByCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 14.0),
                      decoration: BoxDecoration(
                        color: isSentByCurrentUser
                            ? Colors.green
                            : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16.0),
                          topRight: const Radius.circular(16.0),
                          bottomLeft: isSentByCurrentUser
                              ? const Radius.circular(16.0)
                              : Radius.zero,
                          bottomRight: isSentByCurrentUser
                              ? Radius.zero
                              : const Radius.circular(16.0),
                        ),
                      ),
                      child: Text(
                        text,
                        style: TextStyle(
                          color: isSentByCurrentUser
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
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
      body: Column(
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
