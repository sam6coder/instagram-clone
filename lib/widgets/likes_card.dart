import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class LikesCard extends StatefulWidget {
  final snap;
  const LikesCard({Key? key,required this.snap});

  @override
  State<LikesCard> createState() => _LikesCardState();
}

class _LikesCardState extends State<LikesCard> {

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
              radius:30,),
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
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)
                        ),

                      ],)),
                    SizedBox(
                      height: 5,
                    ),
                    RichText(text: TextSpan(
                      children: [

                        TextSpan(
                          text: '${widget.snap['name']}',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.grey)
                          ,
                          // style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ],)),

                    // Padding(
                    //   padding: EdgeInsets.only(top:4,),
                    //   child: Text(
                    //     DateFormat.yMMMd().format(
                    //         widget.snap['datePublished'].toDate()
                    //     ),
                    //     style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),
                    //   ),
                    // )
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
