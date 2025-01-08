import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;

  const CommentScreen({Key? key,required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController=TextEditingController();

  @override
  void dispose(){
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user=Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Center(child: Text('Comments',style: TextStyle(fontSize: 20,color: Colors.white),)),
        automaticallyImplyLeading: false,
      ),

      bottomNavigationBar: SafeArea(child: Container(height: kToolbarHeight,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      padding: EdgeInsets.only(left:20,right: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage('${user.photoUrl}',
            ),radius: 18,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Comment as ${user.username}',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none
              ),
            ),
          ),
          InkWell(
            onTap: () async{
                await FireStoreMethods().commentPost(widget.snap['postId'], user.uid,user.username, _commentController.text, user.photoUrl);
                setState(() {
                  _commentController.text="";
                });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
              child: Text('Post',style: TextStyle(
                color: Colors.blueAccent,fontSize: 20
              ),),
            ),
          )
        ],
      ),)
      ),
      body: StreamBuilder(stream:FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').snapshots(),
          builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(
            ),
          );
        }
        return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context,index)=>CommentCard(snap:(snapshot.data! as dynamic).docs[index].data()));
          },
      ),
    );
  }
}
