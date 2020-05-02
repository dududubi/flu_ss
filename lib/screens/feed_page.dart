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
          'assets/insta_text_logo.png',
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
      stream: Firestore.instance.collection('feed').snapshots(),
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
  Image  _feedImage(Record record) {
    return Image(
      fit: BoxFit.cover,
      image: CacheImage('gs://insta-1e04b.appspot.com/'+record.image),
    );
  }
  Row _feedAction(Record record) {
    return Row(
      children: <Widget>[
        _iconButton(null, 'assets/heart_selected.png', Colors.red),
        _iconButton(null, 'assets/comment.png', Colors.black87),
        _iconButton(null, 'assets/direct_message.png', Colors.black87),
        Spacer(),
        _iconButton(null, 'assets/bookmark.png', Colors.black87),
      ],
    );
  }
  Padding _feedLikes(Record record) {
    return Padding(
      padding: EdgeInsets.only(right: common_gap),
      child: Text(
        '좋아요 57개',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Padding _feedCaption(BuildContext context, Record record) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Comment(
        userName : "test",
        showProfile: true,
        caption : "comment",
      )
    );
  }
}
class Record {
  final String name;
  final String content;
  final String image;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['content'] != null),
        assert(map['image'] != null),
        name = map['name'],
        content = map['content'],
        image = map['image']
        ;

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$content$image>";
}
class FeedPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            _iconButton(null, 'assets/actionbar_camera.png', Colors.black87),
        title: Image.asset(
          'assets/insta_text_logo.png',
          height: 26,
        ),
        actions: <Widget>[
          _iconButton(null, 'assets/actionbar_igtv.png', Colors.black87),
          _iconButton(null, 'assets/direct_message.png', Colors.black87),
        ],
      ),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              _feedHeader(index),
              _feedImage(index),
              _feedAction(index),
              _feedLikes(index),
              _feedCaption(context, index),
            ],
          );
        },
      ),
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
  Widget _feedHeader(int index) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
                getProfileImgPath("UserName")),
            radius: 16,
          ),
        ),
        Expanded(child: Text('UserName')),
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
  final String image1 = "IMG_2456.JPG";
  final String image2 = "IMG_2457.JPG";
  final String image3 = "IMG_2469.JPG";
  final String image4 = "IMG_2475.JPG";
  
  String _getURL(int index)  {
    String url1;
    var imageList = [image1, image2, image3, image4];
    if (index < 4) {
      url1 = 'gs://insta-1e04b.appspot.com/'+imageList[index];
    }
    else {
      url1 = 'https://picsum.photos/id/$index/200/200';
    }
    return url1;
  }
  Image  _feedImage(int index) {
    return Image(
      fit: BoxFit.cover,
      image: CacheImage(_getURL(index)),
    );
  }
  /*
  CachedNetworkImage _feedImage(int index) {
    return CachedNetworkImage(
      imageUrl: _getURL(index),
      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
        return AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
  */
  Row _feedAction(int index) {
    return Row(
      children: <Widget>[
        _iconButton(null, 'assets/heart_selected.png', Colors.red),
        _iconButton(null, 'assets/comment.png', Colors.black87),
        _iconButton(null, 'assets/direct_message.png', Colors.black87),
        Spacer(),
        _iconButton(null, 'assets/bookmark.png', Colors.black87),
      ],
    );
  }
  Padding _feedLikes(int index) {
    return Padding(
      padding: EdgeInsets.only(right: common_gap),
      child: Text(
        '좋아요 57개',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Padding _feedCaption(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Comment(
        userName : "test",
        showProfile: true,
        caption : "comment",
      )
    );
  }
}
