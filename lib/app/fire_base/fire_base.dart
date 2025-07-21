// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyFireBaseHandle {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    //  FirebaseApp app = await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );

    //  await FirebaseAuth.instance.signInAnonymously();
  }
}

class FeedbackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Store feedback (like/dislike)
  Future<void> submitFeedback(String messageId, bool isLiked) async {
    // String userId = _auth.currentUser?.uid ?? "unknown";

    try {
      await _firestore.collection('feedback').add({
        'messageId':
            messageId, // Associate feedback with a specific chat message
        // 'userId': userId,        // Unique user identifier
        'isLiked': isLiked, // true = like, false = dislike
        'timestamp': FieldValue.serverTimestamp(), // Store time
      });

      print("Feedback submitted successfully!");
    } catch (e) {
      print("Error submitting feedback: $e");
    }
  }
}
