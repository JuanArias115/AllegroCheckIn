import 'dart:async';
import 'package:allegrocheckin/main.dart';
import 'package:allegrocheckin/main_page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// The scopes required by this application.
const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

/// The SignInDemo app.
class SignInDemo extends StatefulWidget {
  ///
  const SignInDemo({Key? key}) : super(key: key);

  @override
  State createState() => _SignInDemoState();
}

class _SignInDemoState extends State<SignInDemo> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late Timer _timer;
  User? _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 1), validateLogin);
  }

  validateLogin() {
    var instance = FirebaseAuth.instance;

    var user = instance.currentUser;

    if (user != null) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("main", (Route<dynamic> route) => false);
    }
  }

  // Calls the People API REST endpoint for the signed-in user to retrieve information.

  Future<void> _handleSignIn() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      try {
        await googleSignIn.signOut();
        print("User Sign Out");
      } catch (e) {
        print("Error Sign Out " + e.toString());
      }
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      var user = authResult.user;

      Navigator.of(context)
          .pushNamedAndRemoveUntil("main", (Route<dynamic> route) => false);
    } catch (error) {
      print(error);
    }
  }

  Widget _buildBody() {
    // The user is NOT Authenticated
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        const Image(
          image: AssetImage("assets/Images/LogoAllegro.png"),
          height: 200,
        ),
        SignInButton(
          Buttons.Google,
          onPressed: _handleSignIn,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Container(child: _buildBody())),
    );
  }
}
