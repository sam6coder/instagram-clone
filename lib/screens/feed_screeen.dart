import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screens/story_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/post_card.dart';
import 'package:instagram_clone/widgets/story_card.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';
import '../models/story_model.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late PageController pageController;
  int _currentPage = 0;



  @override
  void initState(){
    super.initState();
    pageController=PageController();
    pageController.addListener(() {
      print('Current Page: ${pageController.page}');
    });

    final user = Provider.of<UserProvider>(context,listen: false);
    user.refreshUser();
  }

  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    // print(FirebaseAuth.instance.currentUser!.uid);
    final width=MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: width>webScreenSize?null:AppBar(
          backgroundColor: width>webScreenSize?webBackgroundColor:mobileBackgroundColor,
          centerTitle: false,
          title: SvgPicture.asset('assets/images/ic_instagram.svg',color:primaryColor,height: MediaQuery.of(context).size.height*0.05,),
          actions: [
            // Padding(
            //   padding: const EdgeInsets.only(right:15.0),
            //   child: Image.asset('assets/images/chat.png',color: Colors.white,height: MediaQuery.of(context).size.height*0.03,),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(right:15.0),
            //   child: Image.asset('assets/images/chat.png',color: Colors.h,height: MediaQuery.of(context).size.height*0.03,),
            // ),

          ],
        ),
      body: (user.user==null)?Center(child: CircularProgressIndicator()):SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   height: MediaQuery.of(context).size.height*0.5,
            //   width: double.infinity,
            //   child: StreamBuilder(stream: FirebaseFirestore.instance.collection('story').orderBy('duration',descending: true).snapshots(),
            //       builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
            //     if(snapshot.connectionState==ConnectionState.waiting){
            //       return CircularProgressIndicator();
            //     }
            //     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            //       return Center(child: Text('No data available', style: TextStyle(color: Colors.white)));
            //     }
            //     // final stories=[];
            //     // Story.fromSnap(snapshot.data!.docs as dynamic);
            //
            //     return SizedBox(
            //       height: MediaQuery.of(context).size.height*0.5,
            //       child: PageView.builder(
            //
            //         physics: BouncingScrollPhysics(),
            //         controller: PageController(),
            //         itemCount: snapshot.data!.docs.length,
            //         itemBuilder: (context,index){
            //         final story=Story.fromSnap(snapshot.data!.docs[index]);
            //         return UserStoryView(
            //               story: story,
            //           onComplete: (){
            //                 if(index+1<snapshot.data!.docs.length){
            //                   pageController.animateToPage(
            //
            //                   )
            //                 }
            //           },
            //
            //         );
            //         },
            //       ),
            //     );
            //
            //
            //     // return PageView.builder(
            //     //   // onPageChanged: (int index) {
            //     //   //   print("Page changed to: $index");
            //     //   // },
            //     //
            //     //   // controller: PageController(),
            //     //
            //     //         scrollDirection: Axis.horizontal,
            //     //         itemCount: snapshot.data!.docs.length,
            //     //         itemBuilder: (context,index){
            //     //           print("index ${index}");
            //     //           return Column(
            //     //           children: [
            //     //             // Padding(
            //     //             //   padding: const EdgeInsets.all(5),
            //     //             //   child: GestureDetector(
            //     //             //     onTap: (){
            //     //             //
            //     //             //       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StoryScreen(snap: snapshot.data!.docs[index].data())));
            //     //             //     },
            //     //             //     child: CircleAvatar(
            //     //             //       radius: 40,
            //     //             //       backgroundColor: Colors.white,
            //     //             //     ),
            //     //             //   ),
            //     //             // ),
            //     //             Text('${snapshot.data!.docs[index]['username']}',style: TextStyle(color: Colors.white),)
            //     //           ],);},
            //     //
            //     //
            //     //
            //     //     );
            //   }),
            //
            //   ),
        
            Container(
              height: MediaQuery.of(context).size.height*0.7,
              child: Padding(
                padding: (MediaQuery.of(context).size.width>webScreenSize)?EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/5,vertical: 30):EdgeInsets.symmetric(horizontal:0),
                child: StreamBuilder(  //listen to realtime data

                stream: FirebaseFirestore.instance.collection('posts').orderBy('datePublished',descending: true).snapshots(),
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
                    }),
              ),
            ),
          ],
        ),
      )

    );
  }
}
