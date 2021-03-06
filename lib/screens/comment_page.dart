import 'package:flutter/material.dart';
import 'package:insta/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/data/model.dart';
import 'package:insta/widgets/comment.dart';
import 'package:insta/constants/size.dart';
import 'package:insta/utils/design.dart';

class CommentPage extends StatefulWidget {
  final Record record; 
  CommentPage({Key key, @required this.record}) : super(key: key);

 @override
 CommentPageState createState() => CommentPageState();
}

class CommentPageState extends State<CommentPage> {
  FirebaseProvider fp;
  final myController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "새 댓글",
          ),
        ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12),
            child : TextField(
                controller : myController,
                decoration: getTextFieldDeco('댓글을 입력하세요.', Icon(Icons.chat_bubble)),
              ),
          ),
          SizedBox(height: 15.0),
          _buildBody(context, widget.record),
        ]
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
          _uploadComment();
        },
        label: Text('등록',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        icon: Icon(Icons.check_circle_outline),
        backgroundColor: Colors.lightBlue[300],
      ),
    );
  }

  Widget _buildBody(BuildContext context, Record record) {
    return Padding(
      padding: EdgeInsets.only(left: common_gap),
      child : StreamBuilder<QuerySnapshot>(
        stream: record.reference.collection("comments").orderBy("timestamp", descending: false).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return _buildCommentList(context, snapshot.data.documents);
        },
      )
    );
  }

  Widget _buildCommentList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 5.0),
      children: snapshot.map((data) => _buildCommentItem(context, data)).toList(),
    );
  }
    
  Widget _buildCommentItem(BuildContext context, DocumentSnapshot data) {
    final comment = RecordComment.fromSnapshot(data);
    return Comment(
      id : comment.id,
      userName : comment.name,
      showProfile: true,
      caption : comment.comment,
      photoUrl: comment.photoUrl,
    );
  }
  void _uploadComment() async {
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Text("   등록 중입니다...")
          ],
        ),
      ));
    await widget.record.reference.collection("comments").add({
      "id" : fp.getUser().uid,
      "name" : fp.getUser().displayName,
      "photoUrl" : fp.getUser().photoUrl,
      "comment": myController.text,
      'timestamp': DateTime.now(),
    });
    myController.clear();
    FocusScope.of(context).requestFocus(FocusNode()); // 키보드 감춤
    _scaffoldKey.currentState.hideCurrentSnackBar();
  }
}

