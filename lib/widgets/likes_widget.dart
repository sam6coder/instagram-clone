import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'likes_card.dart';

class LikesSliderPage extends StatefulWidget {
  // Sample list of users who liked the post
  final snap;
  LikesSliderPage({required this.snap});

  @override
  State<LikesSliderPage> createState() => _LikesSliderPageState();
}

class _LikesSliderPageState extends State<LikesSliderPage> {
  String? username='';


  @override
  Widget build(BuildContext context) {
    bool _isSheetVisible = true;



    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        DraggableScrollableSheet(
            initialChildSize: 0.7, // Start with half screen
            minChildSize: 0, // Minimum screen size when dragged down
            maxChildSize: 1, // Maximum screen size when dragged up
            builder: (BuildContext context, ScrollController scrollController) {
              return Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF25282D),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Drag handle
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Likes",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                       Expanded(
                         child: StreamBuilder(stream:FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('likess').snapshots(),
                          builder: (context,snapshot){
                            if(snapshot.connectionState==ConnectionState.waiting){
                              return Center(
                                child: CircularProgressIndicator(
                                ),
                              );
                            }
                            return ListView.builder(
                                itemCount: (snapshot.data! as dynamic).docs.length,
                                itemBuilder: (context,index)=>LikesCard(snap:(snapshot.data! as dynamic).docs[index].data()));
                          },
                                               ),
                       ),
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }
}
