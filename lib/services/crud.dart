import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Crud {
  Future<void> addData(blogData) async {
    FirebaseFirestore.instance
        .collection('blogs')
        .add(blogData)
        .catchError((e) {
      print(e);
    });
  }

  getData() async {
    return await FirebaseFirestore.instance.collection('blogs').get();
  }
}
