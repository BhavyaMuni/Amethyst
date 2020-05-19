import 'dart:io';

import 'package:amethyst_app/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ImageSelect extends StatefulWidget {
  ImageSelect({Key key, this.imUrl}) : super(key: key);
  final String imUrl;

  @override
  ImageSelectState createState() => ImageSelectState();
}

class ImageSelectState extends State<ImageSelect> {
  File _imageFile;
  bool _loading = false;

  // String downloadUrl;

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _loading = true;
    });

    File selected =
        await ImagePicker.pickImage(source: source, imageQuality: 40);

    if (selected != null) {
      setState(() {
        _imageFile = selected;
        _loading = false;
      });
    }
  }

  /// Starts an upload task
  Future<String> startUpload() async {
    var user = Provider.of<FirebaseUser>(context, listen: false);
    StorageUploadTask _uploadTask;

    /// Unique file name for the file
    final StorageReference _storage = FirebaseStorage.instance
        .ref()
        .child("profile_pictures/${DateTime.now()}-${user.uid}.png");

    if (_imageFile != null) {
      _uploadTask = _storage.putFile(_imageFile);
      // print("uploading");
    }

    var _downloadUrl =
        (await (await _uploadTask.onComplete).ref.getDownloadURL()).toString();

    if (user.uid != null && user.uid != "") {
      Firestore.instance
          .collection("users")
          .document(user.uid)
          .updateData({"photoUrl": _downloadUrl});
    }
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.photoUrl = _downloadUrl;
    await user.updateProfile(updateInfo);

    return _downloadUrl;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageFile = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _pickImage(ImageSource.gallery);
        // try {
        //   _startUpload(user.uid);
        // } catch (e) {
        //   _startUpload(null);
        // }
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Color(0x44000000),
            child: _imageFile == null
                ? Icon(MdiIcons.faceProfile, size: 40)
                : _loading == true
                    ? Center(child: CircularProgressIndicator())
                    : null,
            radius: 80,
            backgroundImage: _imageFile != null
                ? FileImage(_imageFile)
                : widget.imUrl != null || widget.imUrl != ''
                    ? NetworkImage(widget.imUrl)
                    : null,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: 50,
            height: 50,
            child: Icon(MdiIcons.camera),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: TextStyles().baseGrad(),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x44000000),
                      offset: Offset(10, 10),
                      blurRadius: 20,
                      spreadRadius: 5),
                ]),
          )
        ],
      ),
    );
  }
}
