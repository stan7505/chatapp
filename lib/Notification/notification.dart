import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import '../Services/chat_services.dart';
import 'package:flutter/services.dart' show rootBundle;

class PushNotificationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Future<String> serverKey = PushNotificationService.getAccessToken();

  static Future<String> getAccessToken() async {
    final String jsonString = await rootBundle.loadString('lib/assets/serverkey.json');
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final serviceAccountJson = json;

    List<String> scopes = [
      'https://www.googleapis.com/auth/firebase.messaging',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/userinfo.email'
    ];

    final client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    final credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );
    client.close();

    return credentials.accessToken.data;
  }

  Future<void> initialize() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {}

    String? token = await firebaseMessaging.getToken();

    if (token != null) {
      await Chatservices().saveFCMToken(token);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await Chatservices().saveFCMToken(newToken);
    });
  }

  Future<void> sendPushNotification(String fcmToken, String senderEmail,
      String messages, String chatroomID) async {
    final String serverKey = await this.serverKey;
    String endpoint =
        'https://fcm.googleapis.com/v1/projects/YOUR_PROJECT/messages:send';
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Future<String> getusername() async {
      final DocumentSnapshot userdoc =
      await firestore.collection('users').doc(_auth.currentUser!.uid).get();
      return userdoc.get('displayName');
    }

    String username = await getusername();

    final Map<String, dynamic> message = {
      "message": {
        "token": fcmToken,
        "notification": {"title": username, "body": messages},
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "senderEmail": senderEmail,
          "senderID": _auth.currentUser!.uid,
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      // Handle success
    }
  }
}
