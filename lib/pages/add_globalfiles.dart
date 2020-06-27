// import 'package:collegenet/models/users.dart';
import 'package:collegenet/pages/homepage.dart';
import 'package:collegenet/services/loading.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:uuid/uuid.dart';

import 'homepage.dart';

String cnt = "No file chosen";

class AddGlobalFile extends StatefulWidget {
  // AddGlobalFile({this.currentUser});
  // final User currentUser;
  @override
  _AddGlobalFileState createState() => _AddGlobalFileState();
}

class _AddGlobalFileState extends State<AddGlobalFile> {
  File file;
  int length = 0;
  bool isUploading = false;
  bool toggleValue = false;
  String postId = Uuid().v4();
  TextEditingController captionControl = TextEditingController();
  TextEditingController contentControl = TextEditingController();
  TextEditingController linkControl = TextEditingController();
  String userId = currentUser.id,
      username = currentUser.username,
      college = currentUser.college;
  bool isEmptyTitle = false, isEmptyLink = false, isEmptyDes = false;

  String getExtension(File file) {
    int len = file.path.length;
    int idx = file.path.lastIndexOf('.');
    String ext = '';
    for (; idx < len; idx++) {
      ext = ext + file.path[idx];
    }
    print(ext);
    return ext;
  }

  @override
  void initState() {
    super.initState();
    cnt = "No file chosen";
  }

  Future<String> uploadImage(File file) async {
    if (file != null) {
      StorageUploadTask uploadTask =
          storageRef.child("post_$postId" + getExtension(file)).putFile(file);
      StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
      String downloadUrl = await storageSnap.ref.getDownloadURL();
      return downloadUrl;
    } else {
      return null;
    }
  }

  createPostInFirestore(
      {String mediaURL,
      String caption,
      String content,
      String fileExtension,
      bool isFile}) {
    localPostsRef.document(postId).setData({
      "postId": postId,
      "userId": userId,
      "username": username,
      "mediaUrl": mediaURL,
      "caption": caption,
      "content": content,
      "college": college,
      "isLocal": false,
      "isFile": isFile,
      "fileExtension": fileExtension,
      "isApproved":false,
    });
    userWisePostsRef
        .document(userId)
        .collection("posts")
        .document(postId)
        .setData({
      "postId": postId,
      "userId": userId,
      "username": username,
      "mediaUrl": mediaURL,
      "caption": caption,
      "content": content,
      "college": college,
      "isFile": isFile,
      "isLocal": false,
      "fileExtension": fileExtension,
      "isApproved":false,
    });
    setState(() {
      file = null;
      isUploading = false;
      postId = Uuid().v4();
      captionControl.clear();
      contentControl.clear();
      linkControl.clear();
    });
    Navigator.pop(context);
  }

  handleUpload() async {
    setState(() {
      isUploading = true;
    });
    print(toggleValue.toString() + "check ");
    if (toggleValue) {
      String mediaURL = await uploadImage(file);
      print(mediaURL);
      if (mediaURL != null) {
        createPostInFirestore(
          mediaURL: mediaURL,
          caption: captionControl.text,
          content: contentControl.text,
          fileExtension: getExtension(file),
          isFile: toggleValue,
        );
      } else {
        setState(() {
          cnt = "No file chosen.";
        });
      }
    } else {
      String mediaURL = linkControl.text;
      createPostInFirestore(
        mediaURL: mediaURL,
        caption: captionControl.text,
        content: contentControl.text,
        fileExtension: "",
        isFile: toggleValue,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isUploading
        ? circularProgress()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange[800],
              title: Text(
                'Upload files',
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'SaucerBB',
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.91,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.cyan[100],
                      Colors.orange[300],
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 300.0,
                        child: TextField(
                          controller: captionControl,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.title),
                            labelText: "Title",
                            hintText: "My New Post",
                            errorText: isEmptyTitle
                                ? "You cannot leave Title blank"
                                : "",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepOrangeAccent, width: 40.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        "Do you wish to Upload a file or a Link?",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Lato',
                        ),
                      ),
                      Switch(
                        value: toggleValue,
                        onChanged: (value) {
                          setState(() {
                            toggleValue = !toggleValue;
                          });
                        },
                        activeTrackColor: Colors.blue[200],
                        activeColor: Colors.blueAccent[200],
                      ),
                      Text(
                        toggleValue == false
                            ? 'Current Selection: Link'
                            : 'Current Selection: File',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Lato',
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      toggleValue
                          ? Center(
                              child: ButtonTheme(
                                disabledColor: Colors.grey,
                                buttonColor: Colors.lightBlue[100],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: RaisedButton(
                                  child: Text(
                                    'Choose File',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontFamily: 'Lato',
                                    ),
                                  ),
                                  onPressed: () async {
                                    file = await FilePicker.getFile();
                                    setState(() {
                                      if (file == null) {
                                        cnt = "No file chosen";
                                      } else {
                                        String fileName =
                                            file.path.split('/').last;
                                        cnt = "$fileName";
                                        print(file);
                                      }
                                    });
                                  },
                                ),
                              ),
                            )
                          : Container(
                              width: 350.0,
                              child: TextField(
                                controller: linkControl,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesome.external_link),
                                  labelText: "Link",
                                  hintText: "www.google.com",
                                  errorText: isEmptyLink
                                      ? "You cannot leave Link blank"
                                      : "",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepOrangeAccent,
                                        width: 40.0),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: 20),
                      toggleValue
                          ? Center(
                              child: Container(
                                child: Text(
                                  '$cnt',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(height: 20),
                      Container(
                        width: 350.0,
                        height: 100.0,
                        child: TextField(
                          controller: contentControl,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Foundation.clipboard_notes),
                            labelText: "Description",
                            hintText: "Enter your description here",
                            errorText: isEmptyDes
                                ? "You cannot leave Title blank"
                                : "",
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.deepOrangeAccent, width: 40.0),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: ButtonTheme(
                          disabledColor: Colors.grey,
                          buttonColor: Colors.orange[100],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: RaisedButton(
                            onPressed: isUploading
                                ? null
                                : () {
                                    setState(() {
                                      isEmptyTitle =
                                          captionControl.text.isEmpty;
                                      isEmptyDes = contentControl.text.isEmpty;
                                      isEmptyLink = linkControl.text.isEmpty;
                                    });
                                    bool isSubmit =
                                        !(isEmptyDes | isEmptyTitle);
                                    if (!toggleValue) {
                                      isSubmit = isSubmit & !isEmptyLink;
                                    } else {
                                      isSubmit = isSubmit & !(file == null);
                                    }
                                    if (isSubmit) handleUpload();
                                  },
                            child: Text(
                              'Upload',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Lato',
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
