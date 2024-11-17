import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String recieverID;
  final String message;
  final Timestamp timestamp;
  final String senderemail;

  Message(
      {required this.senderID,
      required this.recieverID,
      required this.message,
      required this.timestamp,
      required this.senderemail});

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'recieverID': recieverID,
      'message': message,
      'timestamp': timestamp,
      'senderemail': senderemail
    };
  }
}
