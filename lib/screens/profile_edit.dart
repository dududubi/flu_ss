import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:insta/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cache_image/cache_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final Color yellow = Color(0xfffbc31b);
  final Color orange = Color(0xfffb6900);
  FirebaseProvider fp;
  File _image;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final myController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);
    myController.text = fp.getUser().displayName;
    logger.d(fp.getUser().photoUrl);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "프로필 수정",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: yellow,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [orange, yellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, left:10, right:10),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("갤러리"),
                      onPressed: () {
                        _uploadImageToStorage(ImageSource.gallery);
                      },
                    ),
                    SizedBox(width: 15.0),
                    RaisedButton(
                      child: Text("카메라"),
                      onPressed: () {
                        _uploadImageToStorage(ImageSource.camera);
                      },
                    )
                  ],
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 0.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child:  fp.getUser().photoUrl == null ? 
                            ((_image != null) ? Image.file(_image) : SizedBox(height: 15.0) ) : 
                            Image(
                            fit: BoxFit.cover,
                            image: CacheImage(fp.getUser().photoUrl),
                          )
                          //
                        )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                TextField(
                  controller : myController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '사용자명',
                  )
                ),
                SizedBox(height: 15.0),
                _loadButton(context),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _uploadImageToStorage(ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    img.Image imageIemp = img.decodeImage(image.readAsBytesSync());
    img.Image resizedImg = img.copyResize(imageIemp, width : 500);
    Directory tempDir = await getTemporaryDirectory();
    File(tempDir.path+'temp.png').writeAsBytesSync(img.encodePng(resizedImg));
    image = File(tempDir.path+'temp.png');
    if (image == null) return;
    setState(() {
      _image = image;
    });
  }

  Widget _loadButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
            margin: const EdgeInsets.only(
                top: 6, left: 4.0, right: 4.0, bottom: 25.0),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [yellow, orange],
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: FlatButton(
              onPressed: () {
                _uploadImage();
              },
              child: Text(
                "전송",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _uploadImage() async {
    if(_image == null) {
      return;
    }
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        duration: Duration(seconds: 10),
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Text("   전송 중입니다...")
          ],
        ),
      ));
    var imageId = new DateTime.now().millisecondsSinceEpoch;
    StorageUploadTask storageUploadTask = _firebaseStorage.ref().child(imageId.toString()).putFile(_image);
    await storageUploadTask.onComplete;

    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = myController.text;
    userUpdateInfo.photoUrl = 'gs://insta-1e04b.appspot.com/'+ imageId.toString();
    await fp.getUser().updateProfile(userUpdateInfo);
    await fp.getUser().reload();
    await Firestore.instance.collection('users').document(fp.getUser().uid).setData({
      'id': fp.getUser().uid,
      'email' : fp.getUser().email,
      'name': myController.text,
      'photoUrl': 'gs://insta-1e04b.appspot.com/'+ imageId.toString(),
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    _scaffoldKey.currentState.hideCurrentSnackBar();
    Navigator.of(context).pop();
  }
}