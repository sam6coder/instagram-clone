import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class FireStoreMethods{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  Future<String> uploadPost(
      String description,
      List<Uint8List> file,
      String uid,
      String username,
      String profImage,
      String location
      ) async{
    String res="Some error occured";
    
    try{
      List<String> photoUrl=await StorageMethods().uploadImage('posts', file, true);
      String postId=const Uuid().v1();

      PostModel post=PostModel(
          description: description,
          uid: uid,
          photoUrl: photoUrl,
          username: username,
          postId: postId,
          postUrl: photoUrl.first,
          profileImage: profImage,
          location: location,
          datePublished: DateTime.now(),
          likes: []);

      _firestore.collection('posts').doc(postId).set(post.toJson(
      ));
      res="success";

    }catch(e){
      res=e.toString();


    }
    return res;
  }

  Future<void> likePost(String postId,String uid, List likes) async{
      try {
        if(likes.contains(uid)){
          await _firestore.collection('posts').doc(postId).update({'likes':FieldValue.arrayRemove([uid])

        });
      }else {
          await _firestore.collection('posts').doc(postId).update({'likes':FieldValue.arrayUnion([uid])
          });

        }}catch(e){
        print(e.toString());
      }
  }

  Future<void> likePostDoubleTap(String postId,String uid, List likes) async{
    try {
        await _firestore.collection('posts').doc(postId).update({'likes':FieldValue.arrayUnion([uid])

        });
      }catch(e){
      print(e.toString());
    }
  }

  Future<void> commentPost(String postId,String uid, String username, String text,String profilePic ) async{
    try {
      if(text.isNotEmpty){
        String commentId=Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic':profilePic,
          'userName':username,
          'uid':uid,
          'text':text,
          'commentId':commentId.isNotEmpty,
          'datePublished':DateTime.now()
        });
      }else{
        print('Text is empty');
      }


    }catch(e){
      print(e.toString());
    }
  }


  // Future<String?> getDocumentByFieldValue(String fieldName, dynamic fieldValue) async {
  //   try {
  //     // Reference to the Firestore collection
  //     CollectionReference collectionRef = FirebaseFirestore.instance.collection(
  //         'posts');
  //
  //     // Query for documents where `fieldName` equals `fieldValue`
  //     QuerySnapshot querySnapshot = await collectionRef.where(
  //         fieldName, isEqualTo: fieldValue).get();
  //     return querySnapshot.docs.first['username'] as String;
  //   }catch(e){
  //     print("Error getting document: ${e}");
  //     return null;
  //   }
  // }


}

