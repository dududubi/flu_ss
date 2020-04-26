import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:insta/utils/profile_image_parser.dart';
import 'package:insta/constants/size.dart';
import 'package:insta/widgets/comment.dart';

class FeedPage extends StatelessWidget {
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
  CachedNetworkImage _feedImage(int index) {
    return CachedNetworkImage(
      imageUrl: 'https://picsum.photos/id/$index/200/200',
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
