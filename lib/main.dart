import 'package:flutter/material.dart';
import 'package:email_chat/screens/welcome_screen/welcome_screen.dart';
import 'package:email_chat/screens/login_screen/login_screen.dart';
import 'package:email_chat/screens/registration_screen/registration_screen.dart';
import 'package:email_chat/screens/chat_screen/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inizializza Firebase
  runApp(EmailChat()); // Assicurati che venga chiamato il costruttore corretto
}

class EmailChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.black54)),
      ),
      home: WelcomeScreen(),
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
