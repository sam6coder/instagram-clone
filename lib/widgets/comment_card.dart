import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final String id;
  final String pid;
  const CommentCard({Key? key,required this.snap,required this.id,required this.pid});

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
              radius:25,),
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
                            text: '${widget.snap['userName']}    ',
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        TextSpan(
                          text:DateFormat.yMMMd().format(
                              widget.snap['datePublished'].toDate()
                          ),
                          style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),
                        )

                      ],)),
                    SizedBox(
                      height: 5,
                    ),
                    RichText(text: TextSpan(
                      children: [

                        TextSpan(
                            text: '${widget.snap['text']}',
                            style: TextStyle(fontSize: 17)
                        ),
                      ],)),


                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
