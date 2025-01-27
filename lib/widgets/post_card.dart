import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:instagram_clone/widgets/likes_widget.dart';
import 'package:instagram_clone/widgets/video_player.dart';
import 'package:instagram_clone/widgets/video_thumbnail.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String? username;

  // Future<String?> find() async{
  //
  //   username=await FireStoreMethods().getDocumentByFieldValue('uid', widget.snap['likes'][0]);
  //   return username;
  // }

  int commentLen = 0;

  Future<void> getDocumentByFieldValue() async {
    try {
      if (widget.snap['likes'].length >= 1) {
        CollectionReference collectionRef =
            FirebaseFirestore.instance.collection('users');

        QuerySnapshot querySnapshot = await collectionRef
            .where('uid', isEqualTo: widget.snap['likes'][0])
            .get();
        setState(() {
          username = querySnapshot.docs.first['username'] as String;
          // print(username);
        });
      }
    } catch (e) {
      print("Error getting document: ${e}");
      return null;
    }
  }

  void getDocumentCount() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = querySnapshot.docs.length;

      // Returns the count of documents
    } catch (e) {
      showAlertToast(msg: e.toString(), color: Colors.pink);
    }
  }

  @override
  void initState() {
    super.initState();
    getDocumentByFieldValue();
    getDocumentCount();
  }

  bool isLikeAnimating = false;

  Future<String> checkFileType(String path) async {
    final ref = FirebaseStorage.instance.refFromURL(path);

    try {
      // Fetch file metadata
      final metadata = await ref.getMetadata();
      String? contentType = metadata.contentType;

      if (contentType != null) {
        if (contentType.startsWith('video')) {
          return "video";
        } else if (contentType.startsWith('image')) {
          return "image";
        } else {
          return "unknown";
        }
      }
      return "unknown";
    } catch (e) {
      return "${e.toString()}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    final width=MediaQuery.of(context).size.width;

    return (user == null)
        ? CircularProgressIndicator()
        : Container(
              decoration: BoxDecoration(border: Border.all(
        color: width>webScreenSize?webBackgroundColor:mobileBackgroundColor
              )),
            padding: width>webScreenSize?EdgeInsets.symmetric(vertical: 80):EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Container(

                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                      .copyWith(right: 0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage(widget.snap['profileImage']),
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.snap['username'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            if (widget.snap['location'] != '' ||
                                widget.snap['location'] != null)
                              Text(
                                widget.snap['location']
                                    .split(',')
                                    .sublist(0, 1)
                                    .join(','),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                          ],
                        ),
                      )),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: ListView(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16),
                                          shrinkWrap: true,
                                          children: ['Delete']
                                              .map((e) => InkWell(
                                                    onTap: () async {
                                                      await FireStoreMethods()
                                                          .deletePost(widget
                                                              .snap['postId']);
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12,
                                                              horizontal: 16),
                                                      child: Text(e),
                                                    ),
                                                  ))
                                              .toList()),
                                    ));
                          },
                          icon: Icon(Icons.more_vert))
                    ],
                  ),
                ),
                GestureDetector(
                  onDoubleTap: () async {
                    await FireStoreMethods().likePostDoubleTap(
                        widget.snap['postId'], user.uid, widget.snap['likes']);
                    await FireStoreMethods().likesPostDoubleTap(
                        widget.snap['postId'],
                        user.uid,
                        user.username,
                        user.photoUrl,
                        user.name);
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: (width>webScreenSize)?MediaQuery.of(context).size.height * 0.70:MediaQuery.of(context).size.height * 0.35,
                        width: (width>webScreenSize)?MediaQuery.of(context).size.height * 0.15:double.infinity,
                        child: PageView.builder(
                          itemCount: widget.snap['photoUrl'].length,
                          itemBuilder: (context, index) {
                            final url = widget.snap['photoUrl']
                                [index]; // Get the URL at the current index

                            return FutureBuilder<String>(
                              future: checkFileType(
                                  url), // Call your async function for the current URL
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Show a loading indicator while waiting for the result
                                  return Transform.scale(
                                      scaleY: 0.1,
                                      scaleX: 0.07,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 6,
                                      ));
                                } else if (snapshot.hasError) {
                                  // Handle any errors from the async function
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  // Render the appropriate widget based on the file type
                                  if (snapshot.data == "image") {
                                    return SizedBox(
                                      height:(width>webScreenSize)?MediaQuery.of(context).size.height *
                                          0.70:
                                          MediaQuery.of(context).size.height *
                                              0.35,
                                      width: (width>webScreenSize)?MediaQuery.of(context).size.height * 0.15:double.infinity,
                                      child: Stack(
                                        children:[ Image.network(
                                          widget.snap['photoUrl'][index],
                                          fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,),
                                        if(widget.snap['photoUrl'].length>1)
                                        Positioned(
                                            top:15,
                                            right: 10,
                                            child: Icon(Icons.web_stories,color: Colors.white,size: 25,))],
                                      ),
                                    );
                                  } else if (snapshot.data == "video") {
                                    return SizedBox(
                                        width: double.infinity,
                                        child: VideoPlayerScreen(
                                          videoUrl: widget.snap['photoUrl']
                                              [index],
                                        ));
                                    // Replace with a video player widget
                                  } else {
                                    return Text('Unknown file type');
                                  }
                                } else {
                                  // Handle the case where no data is returned
                                  return Text('No data available');
                                }
                              },
                            );
                          },
                        ),
                      ),
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: isLikeAnimating ? 1 : 0,
                        child: LikeAnimation(
                          child: Icon(
                            Icons.favorite,
                            color: Colors.pink,
                            size: 120,
                          ),
                          isAnimating: isLikeAnimating,
                          duration: Duration(milliseconds: 400),
                          onEnd: () {
                            setState(() {
                              isLikeAnimating = false;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          LikeAnimation(
                              isAnimating:
                                  widget.snap['likes'].contains(user.uid),
                              smallLike: true,
                              child: IconButton(
                                  onPressed: () async {
                                    await FireStoreMethods().likePost(
                                        widget.snap['postId'],
                                        user.uid,
                                        widget.snap['likes']);
                                    await FireStoreMethods().likesPost(
                                        widget.snap['postId'],
                                        user.uid,
                                        user.username,
                                        user.photoUrl,
                                        user.name);
                                    await getDocumentByFieldValue();

                                    setState(() {
                                      isLikeAnimating = false;
                                    });
                                  },
                                  icon:
                                      (widget.snap['likes'].contains(user.uid))
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                              size: 27,
                                            )
                                          : Icon(
                                              Icons.favorite_border,
                                              size: 27,
                                            ))),
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CommentScreen(
                                                  snap: widget.snap,id:widget.snap['postId']
                                                )));
                                  },
                                  child: Image.asset(
                                      'assets/images/comment.png',
                                      color: Colors.white,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.024)),
                              SizedBox(
                                width: 3,
                              ),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(widget.snap['postId'])
                                    .collection('comments')
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<
                                            QuerySnapshot<Map<String, dynamic>>>
                                        snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    Text(
                                      '',
                                      style: TextStyle(fontSize: 17),
                                    );
                                  }
                                  if(snapshot.hasData)
                                  commentLen = snapshot.data!.docs.length;
                                  return (commentLen>=1)?Text(
                                    '${commentLen}',
                                    style: TextStyle(fontSize: 17),
                                  ):Text(
                                    '',
                                    style: TextStyle(fontSize: 17),
                                  );
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset('assets/images/send.png',
                                color: Colors.white,
                                height:
                                    MediaQuery.of(context).size.height * 0.024),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.bookmark_outline_outlined,
                          size: 27,
                        ),
                      ),
                    ))
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.snap['likes'].length >= 1)
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) =>
                                        LikesSliderPage(snap: widget.snap));
                              },
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: DefaultTextStyle(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                  child: Text('Liked by ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: DefaultTextStyle(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                                child: (username != null)
                                    ? Text('${username!} and others',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold))
                                    : Text('...',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 0),
                        child: RichText(
                          text: TextSpan(
                              style: TextStyle(color: primaryColor),
                              children: [
                                TextSpan(
                                  text: widget.snap['username'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                TextSpan(
                                  text: '   ${widget.snap['description']}',
                                  style: TextStyle(fontSize: 17),
                                )
                              ]),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          DateFormat.yMMMd()
                              .format(widget.snap['datePublished'].toDate()),
                          style: TextStyle(fontSize: 16, color: secondaryColor),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
