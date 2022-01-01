import 'package:blog_stack/services/crud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class edit extends StatefulWidget {
  final String? authName, title, des, blogid, imgurl;
  const edit({this.authName, this.title, this.des, this.blogid, this.imgurl});

  @override
  _editState createState() => _editState();
}

class _editState extends State<edit> {
  User? user = FirebaseAuth.instance.currentUser;
  String? author = "", title = "", desc = "", url = "", downloadUrl = "";

  Crud crud = new Crud();

  File? SelectedImage;

  bool _isLoading = false;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      SelectedImage = File(image.path);
    });
  }

  uploadblog() async {
    print("2222222222222222222222");
    if (SelectedImage != null) {
      setState(() {
        _isLoading = true;
      });

      print("3333333333333333333");
      firebase_storage.Reference refer = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('blogImages')
          .child("${randomAlphaNumeric(9)}.jpg");

      print("44444444444444444444444444");

      dynamic task = await refer.putFile(SelectedImage!);

      print("5555555555555555555");

      downloadUrl = await refer.getDownloadURL();

      print("----------------------------------------------------------");
      print(downloadUrl);
      // print(author!);
      // print(desc);
      // print(title);
    }

    Map<String, String> blogMap = {
      "imgUrl": downloadUrl!.length == 0 ? widget.imgurl! : downloadUrl!,
      "authorName": author!.length == 0 ? widget.authName! : author!,
      "title": title!.length == 0 ? widget.title! : title!,
      "desc": desc!.length == 0 ? widget.des! : desc!,
    };

    print("7777777777777");
    await crud.updateData(blogMap, user, widget.blogid);

    print("88888888888888888");
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Blog",
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            Text(
              "Stack",
              style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          GestureDetector(
            onTap: () {
              uploadblog();
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.file_upload)),
          )
        ],
      ),
      body: _isLoading == true
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: SelectedImage != null
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              height: 150.0,
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: Image.file(
                                  SelectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6.0)),
                              height: 150.0,
                              width: MediaQuery.of(context).size.width,
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.black45,
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: widget.title,
                            onChanged: (value) {
                              title = value;
                            },
                          ),
                          TextFormField(
                            maxLines: 5,
                            initialValue: widget.des,
                            onChanged: (value) {
                              desc = value;
                            },
                          ),
                          TextFormField(
                            initialValue: widget.authName,
                            onChanged: (value) {
                              author = value;
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
