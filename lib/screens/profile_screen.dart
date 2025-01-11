import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/edit_profile.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Map<String, dynamic> userData = {};
  int postLen=0;
  int followers=0;
  int following=0;
  bool isLoading=false;

  bool isFollowing=false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {


    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap=await FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

      setState(() {
        userData = snap.data()!;
        postLen=postSnap.docs.length;
        followers=userData['followers'].length;
        following=userData['following'].length;
        isFollowing=userData['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
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
    return Scaffold(

      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: (userData.isNotEmpty)?
          Text(userData['username'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),):null,
        centerTitle: false,
      ),
      body:(userData.isEmpty)?Center(child: CircularProgressIndicator()): ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                          userData['photoUrl']),
                      radius: 48,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStateColumn(postLen, "posts"),
                              buildStateColumn(followers, "followers"),
                              buildStateColumn(following, "following")
                            ],
                          ),
                          FirebaseAuth.instance.currentUser!.uid==widget.uid?
                          FollowButton(textColor: Colors.white, text: 'Edit Profile', function: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditProfile()));
                          }, backgroundColor: Color(0xFF2B3036), borderColor: Color(0xFF2B3036)):
                          (isFollowing)?(isLoading)?Padding(
                            padding: const EdgeInsets.only(top:10.0),
                            child: Container(width: 250,
                                height: 40,decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(5.0),
                                    color: Color(0xFF2B3036), border: Border.all(color: Colors.white)),child: Center(child: SizedBox(width:20,height:20,child: CircularProgressIndicator()))),
                          ):FollowButton(textColor: Colors.green, text: 'UnFollow', function: () async{
                           setState(() {

                             isLoading=true;
                           });
                            await FireStoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);
                           setState(() {
                             isFollowing=false;
                             followers--;
                             isLoading=false;
                           });

                          }, backgroundColor: Color(0xFF2B3036), borderColor: Color(0xFF2B3036)):
                          (isLoading)?Padding(
                            padding: const EdgeInsets.only(top:10.0),
                            child: Container(width: 250,
                                height: 40,decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(5.0),
                                    color: Color(0xFF2B3036), border: Border.all(color: Colors.white)),child: Center(child: SizedBox(width:20,height:20,child: CircularProgressIndicator()))),
                          ):FollowButton(textColor: Colors.white, text: 'Follow', function: () async{
                            setState(() {
                              isLoading=true;
                            });
                           await FireStoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, widget.uid);

                           setState(() {
                             isFollowing=true;
                             followers++;
                             isLoading=false;
                           });

                          }, backgroundColor: Color(0xFF0091EA), borderColor: Color(0xFF0091EA))


                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 10),
                  child: Text('${userData['name']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 1),
                  child: Text(userData['bio'], style: TextStyle(fontSize: 15)),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 7),
                  child: Text('@ ${userData['username']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),



              ],
            ),
          ),
          FutureBuilder(future: FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: widget.uid).get(),
              builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }

            return GridView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data! as dynamic).docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 5,mainAxisSpacing: 5,childAspectRatio: 1),
                itemBuilder: (context,index){
                  DocumentSnapshot snap=(snapshot.data! as dynamic).docs[index];

                  return Container(
                    child: Image(
                      image: NetworkImage(snap['postUrl']),
                      fit: BoxFit.cover,
                    ),
                  );
                });
              })
        ],
      ),
    );
  }
}
