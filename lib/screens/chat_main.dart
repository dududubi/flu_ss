import 'package:flutter/material.dart';
import 'package:insta/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/data/model.dart';
import 'package:cache_image/cache_image.dart';
import 'package:insta/constants/material_color.dart';
import 'package:insta/screens/chat.dart';


class ChatMain extends StatefulWidget {
  @override
  ChatMainState createState() => ChatMainState();
}

class ChatMainState extends State<ChatMain> {
  FirebaseProvider fp;
  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    return 
    Scaffold(
      appBar: AppBar(
        leading : _iconButton(null, 'assets/direct_message.png', Colors.black87),
        title: Text(
          'Direct Message',
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.normal),
        ),
        centerTitle: false,
      ),
      body : Column(
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: Firestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => buildItem(context, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                  );
                }
              },
            ),
          ),
        ],
      )
    );
  }
  Widget _iconButton(onPressed, imageUrl, color) {
    return IconButton(
      onPressed: onPressed,
      icon: ImageIcon(
        AssetImage(imageUrl),
        color: color,
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    final user = Users.fromSnapshot(document);
    if (user.id == fp.getUser().uid) {
      return Container();
    } 
    else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: user.photoUrl != null
                    ? CircleAvatar(
                        backgroundImage: CacheImage(user.photoUrl),
                        radius: 25,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 25.0,
                        color: greyColor,
                      ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '${user.name}',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          'email: ${user.email ?? 'Not available'}',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                          peerId: user.id,
                          peerName: user.name,
                          peerAvatar: user.photoUrl,
                          peerToken : user.token,
                        )));
          },
          color: greyColor2,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }

}