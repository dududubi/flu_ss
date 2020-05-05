import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:insta/utils/profile_image_parser.dart';
import 'package:insta/constants/size.dart';
import 'package:insta/widgets/comment.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cache_image/cache_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:insta/data/model.dart';
import 'package:insta/screens/comment_page.dart';

class FeedPage extends StatefulWidget {
 @override
 FeedPageState createState() {
   return FeedPageState();
 }
}

class FeedPageState extends State<FeedPage> {
  FirebaseProvider fp;
  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading:
            _iconButton(null, 'assets/actionbar_camera.png', Colors.black87),
        title: Image.asset(
          'assets/beensta_text_logo.png',
          height: 26,
        ),
        actions: <Widget>[
          _iconButton(null, 'assets/actionbar_igtv.png', Colors.black87),
          _iconButton(null, 'assets/direct_message.png', Colors.black87),
          _iconButton(() {
            fp.signOut();
          }
          , 'assets/logout.png', Colors.black87),
        ],
      ),
      body: _buildBody(context)
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('feed').orderBy("timestamp", descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    logger.d(record.reference.collection("comments").orderBy("timestamp", descending: true).snapshots().toString());
    return Column(
      children: <Widget>[
        _feedHeader(record),
        _feedContent(record),
        _feedImage(record),
        _feedAction(record),
        _feedLikes(record),
        _feedCaption(context, record),
      ],
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
  Widget _feedHeader(Record record) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: CircleAvatar(
            backgroundImage: CacheImage('gs://insta-1e04b.appspot.com/IMG_2475.JPG'),
            radius: 16,
          ),
        ),
        Expanded(child: Text(record.name)),
        IconButton(
          icon: Icon(
            Icons.more_horiz,
            color: Colors.black87,
          ),
          onPressed: null,
        )
      ],
    );
  }
  Widget _feedContent(Record record) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 15.0),
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: record.content,
              ),
            ]
          ),
        ),
      ],
    );
  }
  FadeInImage _feedImage(Record record){
    return FadeInImage(
      placeholder: MemoryImage(kTransparentImage),
      fit: BoxFit.cover,
      image: CacheImage('gs://insta-1e04b.appspot.com/'+record.image),
    );
  }

  Row _feedAction(Record record) {
    return Row(
      children: <Widget>[
        _iconButton(
          () => record.reference.updateData({'like': FieldValue.increment(1)})
          , 'assets/heart_selected.png', Colors.red),
        _iconButton(() {
            Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => CommentPage( record: record) 
              ),
            );
          }, 'assets/comment.png', Colors.black87
        ),
        _iconButton(null, 'assets/direct_message.png', Colors.black87),
        Spacer(),
        _iconButton(null, 'assets/bookmark.png', Colors.black87),
      ],
    );
  }
  Row _feedLikes(Record record) {
    String like = record.like.toString();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 15,
          height: 30,
        ),
        Text(
          '좋아요 $like 개',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ] 
    );
  }

  Padding _feedCaption(BuildContext context, Record record) {
    return Padding(
      padding: EdgeInsets.only(left: common_gap),
      child : StreamBuilder<QuerySnapshot>(
        stream: record.reference.collection("comments").orderBy("timestamp", descending: true).snapshots(),
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
      userName : comment.name,
      showProfile: true,
      caption : comment.comment,
    );
  }
}
