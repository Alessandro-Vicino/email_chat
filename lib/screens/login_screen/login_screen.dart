import 'package:flutter/material.dart';
import 'package:email_chat/constants.dart';
import 'package:email_chat/roundedButton.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../chat_screen/chat_screen.dart';
import 'auth_service_login.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  String email = '';
  String password = '';
  bool showSpinner = false;
  bool _showBanner = false;

  // Funzione per il login
  void _loginUser(BuildContext context) async {
    setState(() {
      showSpinner = true;
    });

    final user = await _authService.loginUser(email, password);

    setState(() {
      showSpinner = false;
    });

    if (user != null) {
      Navigator.pushNamed(context, ChatScreen.id);
    } else {
      setState(() {
        _showBanner = true;
      });

      // Nascondi il banner dopo 3 secondi
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _showBanner = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 50),
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                SizedBox(height: 48.0),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  cursorColor: Colors.lightBlueAccent,
                  style: TextStyle(color: Colors.black),
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Inserisci la tua email',
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  cursorColor: Colors.lightBlueAccent,
                  style: TextStyle(color: Colors.black),
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Inserisci la tua password',
                  ),
                ),
                SizedBox(height: 24.0),
                showSpinner
                    ? Center(
                        child: SpinKitCircle(
                          color: Colors.lightBlueAccent,
                          size: 50.0,
                        ),
                      )
                    : RoundedButton(
                        color: Colors.lightBlueAccent,
                        text: 'Accedi',
                        onPressed: () {
                          _loginUser(context);
                        },
                      ),
                SizedBox(height: 20.0),
                if (_showBanner)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0), // Arrotonda il banner
                      ),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Email o password errati!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
