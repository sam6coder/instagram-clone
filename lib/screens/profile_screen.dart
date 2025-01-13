import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/edit_profile.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/profile_posts.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/follow_button.dart';
import 'package:instagram_clone/widgets/post_card.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/user_provider.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';


class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isLoading = false;
  String? thumbnailPath;

  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false);
    user.refreshUser();

    getData();
  }

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

  Future<String?> generateThumbnail(String videoPath) async {
    final directory = await getTemporaryDirectory();
    final thumbnailPath = '${directory.path}/thumbnail.jpg';

    await FFmpegKit.execute(
        '-i $videoPath -ss 00:00:01.000 -vframes 1 $thumbnailPath');

    if (await File(thumbnailPath).exists()) {
      return thumbnailPath;
    }
    return null;
  }
  getData() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      setState(() {
        userData = snap.data()!;
        postLen = postSnap.docs.length;
        followers = userData['followers'].length;
        following = userData['following'].length;
        isFollowing = userData['followers']
            .contains(FirebaseAuth.instance.currentUser!.uid);
      });
    } catch (e) {
      showAlertToast(msg: e.toString(), color: Colors.pink);
    }
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
            margin: EdgeInsets.only(top: 4),
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.white),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    print(FirebaseAuth.instance.currentUser!.uid);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: (userData.isNotEmpty)
            ? Text(
                userData['username'],
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )
            : null,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
                onTap: () async {
                  await AuthMethods().signOutUser(context);
                  if (context.mounted)
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Image.asset(
                  'assets/images/turn-off.png',
                  color: Colors.pink,
                  height: 25,
                  width: 25,
                )),
          )
        ],
      ),
      body: (userData.isEmpty)
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                            radius: 48,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStateColumn(postLen, "posts"),
                                    buildStateColumn(followers, "followers"),
                                    buildStateColumn(following, "following")
                                  ],
                                ),
                                FirebaseAuth.instance.currentUser!.uid ==
                                        widget.uid
                                    ? FollowButton(
                                        textColor: Colors.white,
                                        text: 'Edit Profile',
                                        function: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfile()));
                                        },
                                        backgroundColor: Color(0xFF2B3036),
                                        borderColor: Color(0xFF2B3036))
                                    : (isFollowing)
                                        ? (isLoading)
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Container(
                                                    width: 250,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        color:
                                                            Color(0xFF2B3036),
                                                        border: Border.all(
                                                            color:
                                                                Colors.white)),
                                                    child: Center(
                                                        child: SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child:
                                                                CircularProgressIndicator()))),
                                              )
                                            : FollowButton(
                                                textColor: Colors.green,
                                                text: 'UnFollow',
                                                function: () async {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  await FireStoreMethods()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          widget.uid);
                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                    isLoading = false;
                                                  });
                                                },
                                                backgroundColor:
                                                    Color(0xFF2B3036),
                                                borderColor: Color(0xFF2B3036))
                                        : (isLoading)
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0),
                                                child: Container(
                                                    width: 250,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        color:
                                                            Color(0xFF2B3036),
                                                        border: Border.all(
                                                            color:
                                                                Colors.white)),
                                                    child: Center(
                                                        child: SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child:
                                                                CircularProgressIndicator()))),
                                              )
                                            : FollowButton(
                                                textColor: Colors.white,
                                                text: 'Follow',
                                                function: () async {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  await FireStoreMethods()
                                                      .followUser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          widget.uid);

                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                    isLoading = false;
                                                  });
                                                },
                                                backgroundColor:
                                                    Color(0xFF0091EA),
                                                borderColor: Color(0xFF0091EA))
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 10),
                        child: Text('${userData['name']}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 1),
                        child: Text(userData['bio'],
                            style: TextStyle(fontSize: 15)),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 7),
                        child: Text('@ ${userData['username']}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Icon(
                        Icons.grid_view_sharp,
                        color: Colors.white,
                        size: 30,
                      ),
                      Divider(color: Colors.grey, height: 20),
                      // Image.asset('assets/images/minus-horizontal-straight-line.png',color: Colors.white,height: 50,width: 100,),
                    ],
                  ),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (!snapshot.hasData) {
                        return Container(
                            child: Column(
                          children: [
                            Text(
                              'No Posts Yet',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ));
                      } else if ((snapshot.data as dynamic).docs.length == 0) {
                        return Transform.translate(
                          offset: Offset(0, 100), // Move 50px right and 100px down

                          child: Column(
                            children: [
                              Container(
                                  child: Column(
                                children: [
                                  Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(
                                              color: Colors.white, width: 2)),
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 55,
                                      )),
                                  Text(
                                    'No Posts Yet',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )),
                            ],
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    childAspectRatio: 1),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];
                              final url = snap[
                                  'postUrl']; // Get the URL at the current index

                              return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => ProfilePosts(
                                        snap: (snapshot.data! as dynamic).docs,
                                        selectedIndex: index,
                                        uid: widget.uid,
                                      ),
                                    ));
                                  },
                                  child: FutureBuilder<String>(
                                    future: checkFileType(
                                        url), // Call your async function for the current URL
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        // Show a loading indicator while waiting for the result
                                        return Transform.scale(
                                            scaleY: 0.02,
                                            scaleX: 0.02,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ));
                                      } else if (snapshot.hasError) {
                                        // Handle any errors from the async function
                                        return Text('Error: ${snapshot.error}');
                                      } else if (snapshot.hasData) {

                                        if (snapshot.data == "image") {
                                          return Container(
                                            child: Image(
                                              image: NetworkImage(
                                                snap['postUrl'],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        } else if (snapshot.data == "video") {
                                          return FutureBuilder(future: generateThumbnail(snap['postUrl']),
                                              builder: (context,thumbNailsnapshot){
                                            if(!thumbNailsnapshot.hasData){
                                              return SizedBox(
                                                  height: 2,
                                                  width: 2,
                                                  child: CircularProgressIndicator());
                                            }
                                            return  Container(
                                              child: Image.file(File(thumbNailsnapshot.data!),fit: BoxFit.cover,),

                                            );
                                              });
                                          // print(snap['postUrl']);
                                          // return Container(
                                          //   child: Image.file(
                                          //       File(thumbnailPath!)),
                                          // );
                                          // Replace with a video player widget
                                        } else {
                                          return Text('Unknown file type');
                                        }
                                      } else {
                                        // Handle the case where no data is returned
                                        return Text('No data available');
                                      }
                                    },
                                  )
                                  // child: Container(
                                  //   child: Image(
                                  //     image: NetworkImage(snap['postUrl']),
                                  //     fit: BoxFit.cover,
                                  //   ),
                                  // ),
                                  );
                            }),
                      );
                    })
              ],
            ),
    );
  }
}
