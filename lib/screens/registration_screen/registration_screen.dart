import 'package:email_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:email_chat/roundedButton.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'auth_service_registration.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final AuthService _authService = AuthService();
  String email = '';
  String password = '';
  bool showSpinner = false;

  void _registerUser() async {
    setState(() {
      showSpinner = true;
    });

    try {
      await _authService.registerUser(email, password);
      setState(() {
        showSpinner = false;
      });
      // Navigazione alla home o altra schermata dopo la registrazione
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      print('Errore durante la registrazione: $e');
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
                SizedBox(
                    height:
                        50), // Spazio extra per evitare che la tastiera copra tutto
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
                        color: Colors.yellow[700]!,
                        text: 'Registrati',
                        onPressed: () {
                          _registerUser();
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
