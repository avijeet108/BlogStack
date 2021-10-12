import 'dart:io';

import 'package:blog_stack/services/crud.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String? author, title, desc;

  Crud crud = new Crud();

  File? SelectedImage;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      SelectedImage = image;
    });
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
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.file_upload))
        ],
      ),
      body: Container(
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
