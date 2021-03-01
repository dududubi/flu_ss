import 'package:flutter/material.dart';
import 'package:insta/constants/size.dart';
import 'package:insta/firebase_provider.dart';
import 'package:provider/provider.dart';

 class ProfileSideMenu extends StatefulWidget {
 @override
 ProfileSideMenuState createState() {
   return ProfileSideMenuState();
 }
}
class ProfileSideMenuState extends State<ProfileSideMenu> {
  FirebaseProvider fp;
  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey[300]),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(common_gap),
            child: Text(
              'Settings',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            color: Colors.grey[300],
            height: 3,
          ),
          FlatButton.icon(
            onPressed: () => fp.signOut(),
            icon: Icon(Icons.exit_to_app),
            label: Text(
              'Log out',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }
}