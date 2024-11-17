
import 'package:chatapp/Theme/Settings/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Notification/notification.dart';
import 'Pages/ChatPage.dart';
import 'Pages/Login/Auth_page.dart';
import 'Pages/HomePage.dart';
import 'Theme/themes.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // No need to call _handleMessageClick here
}

void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await PushNotificationService().initialize();

  // Get the initial message when the app is launched from a terminated state
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => ThemeProvider(),
    child: MyApp(initialMessage: initialMessage),
  ));
}

class MyApp extends StatefulWidget {
  final RemoteMessage? initialMessage;

  const MyApp({super.key, this.initialMessage});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _handleMessageClick(RemoteMessage message) {
    if (message.data.isNotEmpty) {
      String senderEmail = message.data['senderEmail'];
      String receiverID = message.data['senderID'];
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => Chatpage(
          recieveremail: senderEmail,
          recieverID: receiverID,
        ),
      ));
    }
  }

  @override
  void initState() {
    super.initState();

    // Handle the initial message if the app was launched by a notification
    if (widget.initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleMessageClick(widget.initialMessage!);
      });
    }

    // Handle messages when the app is in the background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageClick(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        'settings': (context) => const Settings(),
        'home': (context) => const Homepage(),
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
    );
  }
}
