import 'package:cloud_firestore/cloud_firestore.dart';
class Record {
  final String name;
  final String content;
  final String image;
  final int like;
  final String photoUrl;
  final Timestamp timestamp;
  final DocumentReference reference;
  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['content'] != null),
        assert(map['image'] != null),
        assert(map['like'] != null),
        name = map['name'],
        content = map['content'],
        image = map['image'],
        like = map['like'],
        photoUrl = map['photoUrl'],
        timestamp = map['timestamp']
        ;
 
  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$content$image>";

}

class RecordComment {
  final String id;
  final String name;
  final String comment;
  final String photoUrl;
  final Timestamp timestamp;
  final DocumentReference reference;

  RecordComment.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['comment'] != null),
        name = map['name'],
        comment = map['comment'],
        id = map['id'],
        photoUrl = map['photoUrl'],
        timestamp = map['timestamp']
        ;

  RecordComment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$name$comment>";
}

class Users {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final DocumentReference reference;

  Users.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        id = map['id'],
        name = map['name'],
        email = map['email'],
        photoUrl = map['photoUrl']
        ;

  Users.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$email$photoUrl>";
}