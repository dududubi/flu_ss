import 'package:flutter/material.dart';
import 'package:insta/firebase_provider.dart';
import 'package:insta/main_page.dart';
import 'package:insta/screens/signin_page.dart';
import 'package:provider/provider.dart';

AuthPageState pageState;

class AuthPage extends StatefulWidget {
  @override
  AuthPageState createState() {
    pageState = AuthPageState();
    return pageState;
  }
}

class AuthPageState extends State<AuthPage> {
  FirebaseProvider fp;

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    logger.d("user: ${fp.getUser()}");
    if (fp.getUser() != null && fp.getUser().isEmailVerified == true) {
      return MainPage();
    } else {
      return SignInPage();
    }
  }
}