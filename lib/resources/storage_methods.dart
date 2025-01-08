import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethods{
  final FirebaseStorage storage=FirebaseStorage.instance;
  final FirebaseAuth auth=FirebaseAuth.instance;
  List<String> downloadUrls=[];

  Future<List<String>>  uploadImage(String childName,List<Uint8List> file,bool isPost) async{
    Reference ref=storage.ref().child(childName).child(auth.currentUser!.uid);


    if(isPost) {
      String id = const Uuid().v1(); //generating uid of post

      if (file.length > 1) {
        Reference fileRef = ref.child(id);


        for (int i = 0; i < file.length; i++) {
          print(file.length);
          String id2 = Uuid().v1();
          print("id : $id2");
          Reference fileRefe=fileRef.child(id2);
          print("second : ${file[i]}");
          UploadTask uploadTask = fileRefe.putData(file[i]);
          TaskSnapshot snap = await uploadTask;
          String downloadUrl = await snap.ref.getDownloadURL();
          downloadUrls.add(downloadUrl);
          print(downloadUrls[i]);
        }
      }
      else {
        Reference refe=ref.child(id); //name of post- uid
          UploadTask uploadTask = refe.putData(file[0]);
          TaskSnapshot snap = await uploadTask;
          String downloadUrl = await snap.ref.getDownloadURL();
          downloadUrls.add(downloadUrl);

      }
    }


    return downloadUrls;
  }

  Future<String>  uploadProfileImage(String childName,Uint8List file,bool isPost) async{
    Reference ref=storage.ref().child(childName).child(auth.currentUser!.uid);

    if(isPost){
      String id=const Uuid().v1();  //generating uid of post
      ref.child(id);  //name of post- uid

    }

      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl=await snap.ref.getDownloadURL();

    return downloadUrl;
  }

}