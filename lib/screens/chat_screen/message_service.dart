import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessagesStream() {
    return _firestore
        .collection('messaggi')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(String messageText, String senderEmail) async {
    await _firestore.collection('messaggi').add({
      'text': messageText,
      'sender': senderEmail,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
