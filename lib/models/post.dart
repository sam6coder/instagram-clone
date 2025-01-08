import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostModel{
  final String description;
  final String uid;
  final List<String> photoUrl;
  final String username;
  final String postId;
  final  datePublished;
  final String postUrl;
  final String profileImage;
  final String location;
  final likes;
  final String name;

  const PostModel({required this.name,required this.description,required this.uid,required this.photoUrl,required this.username,required this.postId,required this.postUrl,required this.profileImage,required this.location,required this.datePublished,required this.likes});

  Map<String,dynamic> toJson()=>{
    "username":username,
    "uid":uid,
    "location":location,
    "photoUrl":photoUrl,
    "likes":likes,
    "profileImage":profileImage,
    "datePublished":datePublished,
    "postUrl":postUrl,
    "description":description,
    "postId":postId,
    "name":name

  };

  static  PostModel fromSnap(DocumentSnapshot snap){
    var snapshot=snap.data() as Map<String,dynamic>;
    return PostModel(postId: snapshot['postId'],
        uid: snapshot['uid'],
        photoUrl: snapshot['photoUrl'],
        username: snapshot['username'],
        description: snapshot['description'],
        location: snapshot['location'],
        profileImage: snapshot['profileImage'],
      postUrl: snapshot['postUrl'],
      likes: snapshot['likes'],
      datePublished: snapshot['datePublished'],
      name:snapshot['name']


    );

  }




}