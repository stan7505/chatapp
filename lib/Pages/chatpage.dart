import 'package:chatapp/Services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chatpage extends StatefulWidget {
  final String recieveremail;
  final String recieverID;

  const Chatpage({
    super.key,
    required this.recieveremail,
    required this.recieverID,
  });

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> with WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getusername() async {
    final DocumentSnapshot userdoc =
        await _firestore.collection('users').doc(widget.recieverID).get();
    return userdoc.get('displayName');
  }

  final FocusNode messageFocusNode = FocusNode();
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    messagehandler();
    WidgetsBinding.instance.addObserver(this);
    messageFocusNode.addListener(() {
      if (messageFocusNode.hasFocus) {
        scrollDown();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollDown());
  }

  void messagehandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      final recieveremail = notification?.title;
      if (notification != null && notification.title != recieveremail) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${notification.title}: ${notification.body}'),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    messageFocusNode.dispose();
    messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    scrollDown();
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      String messageText = messageController.text;
      messageController.clear();
      setState(() {}); // Update the UI immediately
      await Chatservices().sendMessage(
        widget.recieverID,
        messageText,
      );
    }
  }

  Widget _buildMessageList() {
    String senderID = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
      stream: Chatservices().getMessages(senderID, widget.recieverID),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        WidgetsBinding.instance.addPostFrameCallback((_) => scrollDown());
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map<Widget>((doc) {
            return _buildmessageItem(doc);
          }).toList(),
        );
      },
    );
  }

  Widget _buildmessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isSentByCurrentUser =
        data['senderID'] == FirebaseAuth.instance.currentUser!.uid;
    String formattedTime =
        DateFormat('hh:mm a').format(data['timestamp'].toDate());
    return Container(
      margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: isSentByCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                  color: isSentByCurrentUser ? Colors.brown : Colors.white,
                  width: 2),
              color: isSentByCurrentUser
                  ? const Color(0xFFFAF0E6)
                  : Colors.pink.shade100,
              borderRadius: BorderRadius.only(
                topLeft: isSentByCurrentUser
                    ? const Radius.circular(15)
                    : const Radius.circular(0),
                topRight: const Radius.circular(15),
                bottomLeft: isSentByCurrentUser
                    ? const Radius.circular(15)
                    : const Radius.circular(15),
                bottomRight: isSentByCurrentUser
                    ? const Radius.circular(0)
                    : const Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: isSentByCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  data['message'],
                  style: isSentByCurrentUser
                      ? const TextStyle(color: Colors.black, fontSize: 16)
                      : const TextStyle(color: Colors.white, fontSize: 16),
                ),
                data['timestamp'] != null
                    ? Text(
                        formattedTime,
                        style: isSentByCurrentUser
                            ? const TextStyle(color: Colors.black, fontSize: 12)
                            : const TextStyle(
                                color: Colors.white, fontSize: 12),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _builduserinput() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              focusNode: messageFocusNode,
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Enter your message',
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              onTap: () {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => scrollDown());
              },
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send_outlined,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'lib/assets/background.webp',
          color: Colors.grey.withOpacity(1),
          colorBlendMode: BlendMode.darken,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                    future: getusername(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      return Text(
                        snapshot.data.toString(),
                        style: const TextStyle(color: Colors.black),
                      );
                    }),
              ),
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.8)),
          body: Column(
            children: [
              Expanded(
                child: _buildMessageList(),
              ),
              _builduserinput(),
            ],
          ),
        ),
      ],
    );
  }
}
