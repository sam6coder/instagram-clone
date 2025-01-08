import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          title: SvgPicture.asset('assets/images/ic_instagram.svg',color:primaryColor,height: MediaQuery.of(context).size.height*0.05,),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right:15.0),
              child: Image.asset('assets/images/chat.png',color: Colors.white,height: MediaQuery.of(context).size.height*0.03,),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right:15.0),
            //   child: Image.asset('assets/images/chat.png',color: Colors.h,height: MediaQuery.of(context).size.height*0.03,),
            // ),

          ],
        ),
      body: StreamBuilder(  //listen to realtime data

      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
              if(snapshot.connectionState==ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }


              return ListView.builder(
                  itemCount: snapshot.data!.docs.length, //list of doc id- firebase doc
                  itemBuilder: (context,index)=>Container(
                child: PostCard(snap:snapshot.data!.docs[index].data()),
              ));
          })

    );
  }
}
