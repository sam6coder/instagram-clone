import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:instagram_clone/utils/utils.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await firestore.collection('users').doc(currentUser.uid).get();
    return UserModel.fromSnap(snap);
  }

  //sign up
  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file,
      required String name}) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null ||
          name.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user);

        // User user=User(
        //     username:username,
        // uid:cred.user!.uid,
        //     bio:bio,
        //     followers:[],
        //     email:email,
        //     following:[],
        //     photoUrl:photoUrl
        // );

        String photoUrl = await StorageMethods()
            .uploadProfileImage('profilePics', file, false);
        UserModel user = UserModel(
            email: email,
            username: username,
            uid: cred.user!.uid,
            bio: bio,
            followers: [],
            following: [],
            photoUrl: photoUrl,
            name: name);

        firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        // await firestore.collection('users').add({
        //
        // });
        res = 'success';
      } else {
        res = "Please fill all the fields";
      }
    } on FirebaseException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'Password should be of atleast 6 chatacters';
      }
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOutUser() async {
    await _auth.signOut();
  }
}
