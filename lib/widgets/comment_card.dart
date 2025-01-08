import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key,required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {

  @override
  Widget build(BuildContext context) {
    final UserModel user=Provider.of<UserProvider>(context).getUser;

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('${widget.snap['profilePic']}'),
            radius:22,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left:16,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.snap['userName']}',
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),

                    ],)),
                    SizedBox(
                      height: 5,
                    ),
                    RichText(text: TextSpan(
                      children: [

                        TextSpan(
                          text: '${widget.snap['text']}',
                          // style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ],)),

                    Padding(
                      padding: EdgeInsets.only(top:4,),
                      child: Text(
                        DateFormat.yMMMd().format(
                          widget.snap['datePublished'].toDate()
                        ),
                        style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Icon(Icons.favorite_outline,size:18),
            )
          ],
        ),
      ),
    );
  }
}
