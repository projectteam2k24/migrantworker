import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackPage extends StatefulWidget {
  final String userName; // Accepting the user's name as a parameter
  final String contractorUid; // Contractor UID
  final String jobId; // Job ID

  const FeedbackPage({
    super.key,
    required this.userName,
    required this.contractorUid,
    required this.jobId,
  });

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0.0;
  String? jobProviderName; // Variable to store the job provider's name

  @override
  void initState() {
    super.initState();
    _fetchJobProviderName(); // Fetch the job provider's name when the widget is initialized
  }

  // Fetch the job provider's name based on contractorUid
  Future<void> _fetchJobProviderName() async {
    try {
      // Get job provider name from Firestore
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Job Provider') // Use the 'jobprovider' collection
          .doc(FirebaseAuth.instance.currentUser
              ?.uid) // Get the document using contractorUid
          .get();

      if (doc.exists) {
        setState(() {
          jobProviderName = doc['name'] ?? 'Unknown';
        });
      } else {
        setState(() {
          jobProviderName = 'Job provider not found';
        });
      }
    } catch (e) {
      print('Error fetching job provider name: $e');
      setState(() {
        jobProviderName = 'Error fetching name';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback Form"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Title
              const Text(
                "We Value Your Feedback",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your feedback helps us improve. Please rate us and share your thoughts below.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),

              // Star Rating System
              const Text(
                "Rate Us",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Center(
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Color(0xFF3EA120),
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Feedback Text Field
              const Text(
                "Your Feedback",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _feedbackController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: "Write your feedback here...",
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _submitFeedback(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3EA120),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text("Submit Feedback"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitFeedback(BuildContext context) async {
    // Check if rating or feedback text is empty
    if (_rating == 0 || _feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please provide a rating and feedback before submitting.'),
        ),
      );
      return;
    }

    try {
      final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserUid == null) {
        throw Exception("User not authenticated");
      }

      final currentUser = FirebaseAuth.instance.currentUser;

      // Save feedback to Firestore
      await FirebaseFirestore.instance.collection('feedbacks').add({
        'message': _feedbackController.text.trim(), // Feedback message
        'rating': _rating, // Rating number
        'contractorUid': widget.contractorUid, // Contractor UID
        'jobProviderUid': currentUserUid, // Job provider UID (current user)
        'jobId': widget.jobId, // Job ID
        'timestamp': FieldValue.serverTimestamp(), // Timestamp
        'jobProviderName':
            jobProviderName, // Job provider name fetched from Firestore
      });

      // Clear the input fields
      _feedbackController.clear();
      setState(() {
        _rating = 0;
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Feedback Submitted"),
          content: const Text(
            "Thank you for your feedback! We appreciate your time.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle errors during feedback submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting feedback: ${e.toString()}'),
        ),
      );
    }
  }
}
