import 'package:blog_stack/services/crud.dart';
import 'package:blog_stack/views/create_blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Crud crud = new Crud();
  QuerySnapshot? blogsSnapshot;
  bool fetching = true;

  Widget blogsList() {
    return Container(
      child: Column(
        children: [
          ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              itemCount: blogsSnapshot!.docs.length,
              itemBuilder: (context, index) {
                print((blogsSnapshot!.docs[index].data()));
                return BlogsTile(
                  author: ((blogsSnapshot!.docs[index].data())!
                      as Map)['authorName'],
                  imgurl:
                      ((blogsSnapshot!.docs[index].data())! as Map)['imgUrl'],
                  description:
                      ((blogsSnapshot!.docs[index].data())! as Map)['desc'],
                  title: ((blogsSnapshot!.docs[index].data())! as Map)['title'],
                );
              }),
        ],
      ),
    );
  }

  getDetails() async {
    final result = await crud.getData();
    blogsSnapshot = result;
    // print(blogsSnapshot);
    setState(() {
      fetching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getDetails();
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
      ),
      body: fetching
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: blogsList(),
            ),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateBlog()));
              },
              child: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  String? imgurl, author, title, description;

  BlogsTile({this.imgurl, this.author, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 150,
      child: Stack(
        children: [
          ClipRRect(
            child: Image.network(
              imgurl!,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.black45.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title!,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  description!,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(author!),
              ],
            ),
          )
        ],
      ),
    );
  }
}
