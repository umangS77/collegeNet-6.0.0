import 'package:collegenet/models/users.dart';
import 'package:collegenet/pages/homepage.dart';
import 'package:collegenet/services/loading.dart';
import 'package:collegenet/widgets/viewpost.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FilePost extends StatefulWidget {
  final String postId;
  final String userId;
  final String username;
  final String caption;
  final String content;
  final String mediaUrl;
  final String college;
  final bool isLocal;
  final bool isFile;
  final String fileExtension;

  FilePost({
    this.postId,
    this.userId,
    this.username,
    this.caption,
    this.content,
    this.mediaUrl,
    this.college,
    this.isLocal,
    this.fileExtension,
    this.isFile,
  });
  factory FilePost.fromDocument(DocumentSnapshot doc) {
    return FilePost(
      postId: doc['postId'],
      userId: doc['userId'],
      username: doc['username'],
      caption: doc['caption'],
      content: doc['content'],
      mediaUrl: doc['mediaUrl'],
      college: doc['college'],
      isLocal: doc['isLocal'],
      fileExtension: doc['fileExtension'],
      isFile: doc['isFile'],
    );
  }
  @override
  _FilePostState createState() => _FilePostState(
        postId: this.postId,
        userId: this.userId,
        mediaUrl: this.mediaUrl,
        content: this.content,
        caption: this.caption,
        username: this.username,
        college: this.college,
        isLocal: this.isLocal,
        fileExtension: this.fileExtension,
        isFile: this.isFile,
      );
}

class _FilePostState extends State<FilePost> {
  final String postId;
  final String userId;
  final String username;
  final String caption;
  final String content;
  final String mediaUrl;
  final String college;
  final bool isLocal;
  final bool isFile;
  final String fileExtension;

  _FilePostState({
    this.postId,
    this.userId,
    this.username,
    this.caption,
    this.content,
    this.mediaUrl,
    this.college,
    this.isLocal,
    this.fileExtension,
    this.isFile,
  });

  String details;
  bool isFilePostOwner;
  String filepath;
  int temp;
  double randnum = 1;

  buildPostHeader() {
    // print(content)
    print(isFile);
    isFilePostOwner = userId == currentUser.id;
    details = content;
    return FutureBuilder(
        future: usersRef.document(userId).get(),
        builder: (content, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          // User user = User.fromDocument(snapshot.data);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostView(
                    caption: caption,
                    username: username,
                    content: details,
                    url: mediaUrl,
                    fileExt: fileExtension,
                    postId: postId,
                    isFile: isFile,
                  ),
                ),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(filepath),
              ),
              title: Text(
                caption,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle:
                  (isFile) ? Text("Type of File : $fileExtension") : Text(""),
              trailing: isFilePostOwner
                  ? IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () => handleDeleteFilePost(context))
                  : Text(''),
            ),
          );
        });
  }

  deleteFilePost() {
    localPostsRef.document(postId).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    userWisePostsRef
        .document(userId)
        .collection("posts")
        .document(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    storageRef.child("post_$postId" + "$fileExtension").delete();
  }

  handleDeleteFilePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this post"),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  deleteFilePost();
                },
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    temp = userId.codeUnitAt(0);
    randnum = 1 + (temp - 48) / 12;
    temp = randnum.ceil();
    // print("yo: " + temp.toString());
    filepath = 'assets/images/avatars/av$temp.png';
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildPostHeader(),
        ],
      ),
    );
  }
}
