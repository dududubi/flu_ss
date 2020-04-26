import 'package:flutter/material.dart';
import 'package:insta/main_page.dart';
import 'package:insta/constants/material_color.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: white,
      ),
      home: MainPage(),
    );
  }
}
 