import 'package:blog_stack/screens/edit.dart';
import 'package:blog_stack/screens/login.dart';
import 'package:blog_stack/services/crud.dart';
import 'package:blog_stack/views/create_blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  Crud crud = new Crud();
  Stream<QuerySnapshot>? blogsStream;
  bool fetching = true;
  String? name;

  Future<void> getUserName() async {
    FirebaseFirestore.instance
        .collection('blogs')
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        name = value.data()!['username'].toString();
      });
    });
  }

  Widget blogsList() {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "$name",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.blue),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: blogsStream,
              builder: (context, snapshot) {
                return Container(
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        print((snapshot.data!.docs[index].data()));
                        return BlogsTile(
                          id: snapshot.data!.docs[index].id,
                          author: ((snapshot.data!.docs[index].data())!
                              as Map)['authorName'],
                          imgurl: ((snapshot.data!.docs[index].data())!
                              as Map)['imgUrl'],
                          description: ((snapshot.data!.docs[index].data())!
                              as Map)['desc'],
                          title: ((snapshot.data!.docs[index].data())!
                              as Map)['title'],
                        );
                      }),
                );
              }),
        ],
      ),
    );
  }

  getDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    final result = await crud.getData(user);
    blogsStream = result;
    // print(blogsSnapshot);
    setState(() {
      fetching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserName();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return fetching
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Blog",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Stack",
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      fetching = true;
                    });
                    logout(context);
                    setState(() {
                      fetching = false;
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Icon(Icons.logout)),
                )
              ],
            ),
            body: fetching
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SingleChildScrollView(
                    child: Container(
                      child: blogsList(),
                    ),
                  ),
            floatingActionButton: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateBlog()));
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

class BlogsTile extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;

  String? imgurl, author, title, description, id;

  BlogsTile({this.imgurl, this.author, this.title, this.description, this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 200,
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
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black45.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      description!.length > 140
                          ? "${description!.substring(0, 139)}...."
                          : description!,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("By:  " "$author"),
                ],
              ),
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => edit(
                                authName: author,
                                title: title,
                                des: description,
                                blogid: id,
                                imgurl: imgurl,
                              )));
                },
                icon: Icon(Icons.edit),
              )),
          Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('blogs')
                      .doc(user!.uid)
                      .collection('blog')
                      .doc(id)
                      .delete();
                },
                icon: Icon(Icons.delete),
              ))
        ],
      ),
    );
  }
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Fluttertoast.showToast(msg: "Logged out successfully");

  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
}
