import 'package:cloud_firestore/cloud_firestore.dart';
class Record {
  final String name;
  final String content;
  final String image;
  final int like;
  final DocumentReference reference;
  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['content'] != null),
        assert(map['image'] != null),
        assert(map['like'] != null),
        name = map['name'],
        content = map['content'],
        image = map['image'],
        like = map['like']
        ;
 
  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$content$image>";

}

class RecordComment {
  final String name;
  final String comment;
  final DocumentReference reference;

  RecordComment.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['comment'] != null),
        name = map['name'],
        comment = map['comment']
        ;

  RecordComment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$name$comment>";
}