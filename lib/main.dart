import 'package:flutter/material.dart';
import 'package:insta/constants/material_color.dart';
import 'package:insta/screens/auth_page.dart';
import 'package:provider/provider.dart';
import 'firebase_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseProvider>(
            create: (_) => FirebaseProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: white,
        ),
        home: AuthPage(),
      )
    );
  }
}
 