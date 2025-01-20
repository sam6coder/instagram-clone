import 'dart:typed_data';
import 'package:instagram_clone/utils/utils.dart';
import 'package:pro_image_editor/utils/parser/double_parser.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

import '../models/story_model.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
      String description,
      List<Uint8List> file,
      String uid,
      String username,
      String profImage,
      String location,
      String name) async {
    String res = "Some error occured";

    try {
      List<String> photoUrl =
          await StorageMethods().uploadImage('posts', file, true);
      String postId = const Uuid().v1();

      PostModel post = PostModel(
          description: description,
          uid: uid,
          photoUrl: photoUrl,
          username: username,
          postId: postId,
          postUrl: photoUrl.first,
          profileImage: profImage,
          location: location,
          datePublished: DateTime.now(),
          likes: [],
          name: name);

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> uploadStory(
    String userId,
    String username,
    List<Uint8List> files,
      String photoUrl
  ) async {
    String res = "some error occured";
    try {
      List<String> storyU =
          await StorageMethods().uploadImage('story', files, true);

      String storyId = const Uuid().v1();

      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('story');

      QuerySnapshot querySnapshot =
          await collectionRef.where('username', isEqualTo: username).get();
      if (querySnapshot.size == 0) {
        Story story = Story(
            storyUrl: storyU,
            duration: DateTime.now(),
            userId: userId,
            username: username,
            storyId: storyId,
        photoUrl: photoUrl);
        _firestore.collection('story').doc(storyId).set(story.toJson());
      } else {
        final usr = querySnapshot.docs.first['username'];
        print("username ${usr}");
        final uid = querySnapshot.docs.first.id;
        await _firestore
            .collection('story')
            .doc(uid)
            .update({'storyUrl': FieldValue.arrayUnion(storyU)});
      }

      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likePostDoubleTap(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likesPostDoubleTap(String postId, String uid, String username,
      String profilePic, String name) async {
    try {
      CollectionReference document = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likess');
      QuerySnapshot querySnapshot =
          await document.where('uid', isEqualTo: uid).get();
      if (querySnapshot.docs.isEmpty) {
        String likesId = Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('likess')
            .doc(likesId)
            .set({
          'profilePic': profilePic,
          'userName': username,
          'uid': uid,
          'datePublished': DateTime.now(),
          'name': name
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> commentPost(String postId, String uid, String username,
      String text, String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'userName': username,
          'uid': uid,
          'text': text,
          'commentId': commentId.isNotEmpty,
          'datePublished': DateTime.now()
        });
      } else {
        print('Text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likesPost(String postId, String uid, String username,
      String profilePic, String name) async {
    try {
      CollectionReference document = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likess');
      QuerySnapshot querySnapshot =
          await document.where('uid', isEqualTo: uid).get();
      if (querySnapshot.docs.isEmpty) {
        String likesId = Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('likess')
            .doc(likesId)
            .set({
          'profilePic': profilePic,
          'userName': username,
          'uid': uid,
          'datePublished': DateTime.now(),
          'name': name
        });
      } else {
        String did = querySnapshot.docs[0].id;
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likess')
            .doc(did)
            .delete();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> deleteComment(String commentId, String postId) async {
    try {
      _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      showAlertToast(msg: e.toString(), color: Colors.pink);
    }
  }

  Future<String> editProfile(String uid, String username, String bio,
      String name, String? gender, String? pronoun) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'username': username,
        'name': name,
        'bio': bio,
        'gender': gender,
        'pronoun': pronoun
      });
      print("success");
      return "success";
    } catch (e) {
      showAlertToast(msg: e.toString(), color: Colors.pink);
      return e.toString();
    }
  }
}
