import 'package:chatapp/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Notification/notification.dart';

class Chatservices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("users").snapshots().map((query) {
      return query.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverID, String message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserID,
      recieverID: receiverID,
      message: message,
      timestamp: timestamp,
      senderemail: currentUserEmail,
    );

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatroomID = ids.join('_');

    await _firestore
        .collection('chats')
        .doc(chatroomID)
        .collection('messages')
        .add(newMessage.toMap());

    DocumentSnapshot receiverSnapshot =
        await _firestore.collection('users').doc(receiverID).get();
    String? fcmToken = receiverSnapshot.get('fcmToken');

    if (fcmToken != null) {
      await PushNotificationService().sendPushNotification(
        fcmToken,
        currentUserEmail,
        message,
        chatroomID,
      );
    }
  }

  Stream<QuerySnapshot> getMessages(String currentID, String recieverID) {
    List<String> ids = [currentID, recieverID];
    ids.sort();
    String chatroomID = ids.join('_');

    return _firestore
        .collection('chats')
        .doc(chatroomID)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  Future<void> saveFCMToken(String token) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      final String currentUserID = currentUser.uid;
      await _firestore.collection('users').doc(currentUserID).update({
        'fcmToken': token,
      });
    }
  }
}
