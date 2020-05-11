import 'package:flutter/material.dart';
import 'package:insta/constants/size.dart';
import 'package:intl/intl.dart';
import 'package:cache_image/cache_image.dart';
 
class Comment extends StatelessWidget {
  final String id;
  final String userName;
  final bool showProfile;
  final DateTime dateTime;
  final String caption;
  final String photoUrl;
 
  Comment({
    @required this.id,
    @required this.userName,
    this.showProfile = false,
    this.dateTime,
    @required this.caption,
    this.photoUrl,
  }); 
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Visibility(
          visible: showProfile,
          child: CircleAvatar(
            backgroundImage: photoUrl == null ? null : CacheImage(photoUrl),
            radius: profile_radius,
          ),
        ),
        Visibility(
          visible: showProfile,
          child: SizedBox(
            width: common_xs_gap,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: userName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '  '),
                      TextSpan(
                          text: caption),
                    ]),
              ),
              SizedBox(
                height: common_xxxs_gap,
              ),
              Visibility(
                visible: dateTime != null,
                child: dateTime == null
                    ? SizedBox()
                    : Text(
                        new DateFormat("yyyy-MM-dd").format(dateTime),
                        style: TextStyle(color: Colors.grey[700], fontSize: 11),
                      ),
              ),
            ],
          ),
        )
      ],
    );
  }
}