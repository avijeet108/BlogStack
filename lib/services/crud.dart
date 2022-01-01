import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:blog_stack/services/user_model.dart';

class Crud {
  Future<void> addData(blogData, user) async {
    FirebaseFirestore.instance
        .collection('blogs')
        .doc(user.uid)
        .collection("blog")
        .add(blogData)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> updateData(blogData, user, blogid) async {
    FirebaseFirestore.instance
        .collection('blogs')
        .doc(user.uid)
        .collection("blog")
        .doc(blogid)
        .update(blogData)
        .catchError((e) {
      print(e);
    });
  }

  getData(user) async {
    return await FirebaseFirestore.instance
        .collection('blogs')
        .doc(user.uid)
        .collection('blog')
        .snapshots();
  }
}
