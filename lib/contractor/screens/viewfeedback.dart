import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackViewPage extends StatefulWidget {
  @override
  _FeedbackViewPageState createState() => _FeedbackViewPageState();
}

class _FeedbackViewPageState extends State<FeedbackViewPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Format Firestore Timestamp to a readable date
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'N/A';
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  // Delete Feedback from Firestore
  Future<void> _deleteFeedback(String feedbackId) async {
    try {
      await _firestore.collection('feedbacks').doc(feedbackId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete feedback')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get current user UID
    final String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Feedback'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('feedbacks')
              .where('contractorUid', isEqualTo: currentUserUid)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              print('Error loading feedback: ${snapshot.error}'); // Log error
              return const Center(
                child: Text(
                  'Failed to load feedback. Please try again later.',
                  style: TextStyle(color: Colors.red),
                ),
              );
              print(currentUserUid);
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No feedback available.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            final feedbacks = snapshot.data!.docs;

            return ListView.builder(
              itemCount: feedbacks.length,
              itemBuilder: (context, index) {
                final feedback = feedbacks[index];
                final data = feedback.data() as Map<String, dynamic>;

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade700,
                      backgroundImage: data['profileImage'] != null
                          ? NetworkImage(data['profileImage'])
                          : null,
                      child: data['profileImage'] == null
                          ? Text(
                              data['name'] != null && data['name']!.isNotEmpty
                                  ? data['name']![0].toUpperCase()
                                  : '?',
                              style: const TextStyle(color: Colors.white),
                            )
                          : null,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['jobProviderName'] ??
                              'Anonymous', // Job provider name
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: List.generate(5, (i) {
                            return Icon(
                              i < (data['rating'] ?? 0)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            );
                          }),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          data['message'] ??
                              'No feedback provided.', // Feedback message
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Submitted on: ${_formatTimestamp(data['timestamp'])}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Confirm deletion before proceeding
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete Feedback'),
                              content: const Text(
                                  'Are you sure you want to delete this feedback?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deleteFeedback(feedback.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
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
