import 'dart:io';

import 'package:amethyst_app/styles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageSelect extends StatefulWidget {
  ImageSelect({Key key}) : super(key: key);

  @override
  _ImageSelectState createState() => _ImageSelectState();
}

class _ImageSelectState extends State<ImageSelect> {
  File _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  StorageUploadTask _uploadTask;
  String downloadUrl;

  /// Starts an upload task
  void _startUpload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// Unique file name for the file
    final StorageReference _storage = FirebaseStorage.instance
        .ref()
        .child("profile_pictures/${DateTime.now()}.png");

    _uploadTask = _storage.putFile(_imageFile);

    var _downloadUrl =
        (await (await _uploadTask.onComplete).ref.getDownloadURL()).toString();

    prefs.setString('photoUrl', _downloadUrl);

    setState(() {
      downloadUrl = _downloadUrl;
    });
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _pickImage(ImageSource.gallery);
        _startUpload();
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Color(0x44000000),
            child: downloadUrl != null && downloadUrl.length != 0
                ? Container()
                : Icon(MdiIcons.faceProfile),
            radius: 80,
            backgroundImage: NetworkImage(downloadUrl),
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
}
