import 'dart:io';

import 'package:amethyst_app/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageSelect extends StatefulWidget {
  ImageSelect({Key key, this.imUrl}) : super(key: key);
  final String imUrl;

  @override
  _ImageSelectState createState() => _ImageSelectState();
}

class _ImageSelectState extends State<ImageSelect> {
  File _imageFile;
  bool _loading = false;

  StorageUploadTask _uploadTask;
  String downloadUrl;

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    if (selected != null) {
      setState(() {
        _imageFile = selected;
      });
    }
  }

  /// Starts an upload task
  void _startUpload(String userUid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// Unique file name for the file
    final StorageReference _storage = FirebaseStorage.instance
        .ref()
        .child("profile_pictures/${DateTime.now()}.png");

    if (_imageFile != null) {
      _uploadTask = _storage.putFile(_imageFile);
    } else {
      _loading = false;
    }

    var _downloadUrl =
        (await (await _uploadTask.onComplete).ref.getDownloadURL()).toString();

    if (userUid != null && userUid != "") {
      Firestore.instance
          .collection("users")
          .document(userUid)
          .updateData({"photoUrl": _downloadUrl});
    } else {
      prefs.setString('photoUrl', _downloadUrl);
    }

    setState(() {
      downloadUrl = _downloadUrl;
      _loading = false;
    });
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    return GestureDetector(
      onTap: () async {
        await _pickImage(ImageSource.gallery);
        try {
          _startUpload(user.uid);
        } catch (e) {
          _startUpload(null);
        }
        setState(() {
          _loading = true;
        });
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Color(0x44000000),
            child: showLoading(),
            radius: 80,
            backgroundImage: showImage(),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: 50,
            height: 50,
            child: Icon(MdiIcons.camera),
            decoration: BoxDecoration(
                shape: BoxShape.circle, gradient: TextStyles().baseGrad()),
          )
        ],
      ),
    );
  }

  NetworkImage showImage() {
    if (widget.imUrl != null) {
      return NetworkImage(widget.imUrl);
    } else {
      if (downloadUrl != null && downloadUrl.length != 0) {
        return NetworkImage(downloadUrl);
      } else {
        return NetworkImage("");
      }
    }
  }

  Widget showLoading() {
    if (_loading == true) {
      return CircularProgressIndicator();
    } else {
      if (downloadUrl != null && downloadUrl.length != 0 ||
          widget.imUrl != null) {
        return Container();
      } else {
        return Icon(
          MdiIcons.faceProfile,
          size: 40,
        );
      }
    }
  }
}
