import 'dart:io';
import 'package:blog_stack/services/crud.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_core/firebase_core.dart' as firbase_core;

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String? author, title, desc;

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
    if (SelectedImage != null) {
      setState(() {
        _isLoading = true;
      });

      firebase_storage.Reference refer = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('blogImages')
          .child("${randomAlphaNumeric(9)}.jpg");

      dynamic task = await refer.putFile(SelectedImage!);

      String downloadUrl = await refer.getDownloadURL();

      // print("----------------------------------------------------------");
      // print(downloadUrl);

      Map<String, String> blogMap = {
        "imgUrl": downloadUrl,
        "authorName": author!,
        "title": title!,
        "desc": desc!,
      };

      await crud.addData(blogMap);
      Navigator.pop(context);
      setState(() {
        _isLoading = false;
      });
    } else {
      print("@@@@@@@");
    }
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
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
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
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Author Name",
                          ),
                          onChanged: (value) {
                            author = value;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Title",
                          ),
                          onChanged: (value) {
                            title = value;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Description",
                          ),
                          onChanged: (value) {
                            desc = value;
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
