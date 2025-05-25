import 'package:flutter/material.dart';
import 'package:email_chat/constants.dart';
import 'package:email_chat/screens/welcome_screen/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service_chat.dart';
import 'message_service.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AuthService _authService = AuthService();
  final MessageService _messageService = MessageService();

  User? loggedInUser;
  late String messageText;
  late TextEditingController messageController;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
    getCurrentUser();
  }

  void getCurrentUser() {
    loggedInUser = _authService.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                WelcomeScreen.id,
                (route) => false,
              );
            },
            child: Text(
              'Disconnetti',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
        title: Text('⚡️Chat',
            style: TextStyle(color: Colors.white, fontSize: 25.0)),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/sfondo.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _messageService.getMessagesStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final messages = snapshot.data!.docs;
                    List<MessageWidget> messageWidgets = [];
                    for (var message in messages) {
                      final messageText = message['text'];
                      final messageSender = message['sender'];

                      final bool isMe = loggedInUser?.email == messageSender;

                      final messageWidget = MessageWidget(
                        sender: messageSender,
                        text: messageText,
                        isMe: isMe,
                        isOtherUser: !isMe,
                      );
                      messageWidgets.add(messageWidget);
                    }

                    return ListView(
                      reverse: true,
                      children: messageWidgets,
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                decoration: kMessageContainerDecoration.copyWith(
                  border: Border.all(color: Colors.transparent),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        onChanged: (value) {
                          setState(() {
                            messageText = value;
                          });
                        },
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: kMessageTextFieldDecorationInput.copyWith(
                          hintText: 'Scrivi un messaggio...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        if (messageText.isNotEmpty) {
                          _messageService.sendMessage(
                            messageText,
                            loggedInUser?.email ?? 'Utente sconosciuto',
                          );
                          messageController.clear();
                          setState(() {
                            messageText = '';
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final bool isOtherUser;

  MessageWidget({
    required this.sender,
    required this.text,
    required this.isMe,
    required this.isOtherUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: isMe
                ? Colors.blue[200]
                : isOtherUser
                    ? Colors.yellow[200]
                    : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: isMe ? Radius.circular(15) : Radius.zero,
              bottomRight: isMe ? Radius.zero : Radius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sender,
                style: TextStyle(
                  fontSize: 12,
                  color: isMe ? Colors.white : Colors.black54,
                ),
              ),
              SizedBox(height: 5),
              Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isMe ? Colors.black : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
