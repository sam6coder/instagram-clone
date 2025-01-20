


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/story_screen.dart';
import 'package:instagram_clone/widgets/video_thumbnail.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

import '../models/story_model.dart';

class StoryCard extends StatefulWidget {

  final  story;
  final int initialIndex;

  const StoryCard({required this.story, required this.initialIndex});

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  @override
  void initState(){
    super.initState();
    pageController=PageController();
  }
  
  final storyController = StoryController();
  late PageController pageController;

  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
          itemCount: widget.story.length,
          itemBuilder:(context,index){
            return StoryScreen(
              snap:widget.story[index],
              onComplete:(){
                if(index+1<widget.story.length){
                  pageController.animateToPage(index+1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                }else{
                  Navigator.pop(context);
                }
              }
            );
          }),
    );


  }
}


// class StoryCard extends StatefulWidget {
//   final snap;
//
//   StoryCard({required this.snap});
//
//   @override
//   State<StoryCard> createState() => _StoryCardState();
// }

// class _StoryCardState extends State<StoryCard> {
//   late PageController _pageController;
//
//
// @override
// void initState(){
//   super.initState();
//   _pageController=PageController();
//
// }
//   final dummyData = [
//     {'username': 'Alice'},
//     {'username': 'Bob'},
//     {'username': 'Charlie'},
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//   print("heyyyy ${widget.snap}");
//   print("len ${widget.snap.length}");
//     return SizedBox(
//         width: double.infinity,
//         height: MediaQuery.of(context).size.height*0.15,
//         child: PageView.builder(
//           scrollDirection: Axis.horizontal,
//           physics: BouncingScrollPhysics(),
//           controller: PageController(),
//           itemCount: widget.snap.length,
//           itemBuilder:(context,index){
//             print("index ${index}");
//             return Text('${widget.snap[index]['username']}');}
//             // return Column(
//             //   children: [
//             //     Padding(
//             //       padding: const EdgeInsets.all(5),
//             //       child: GestureDetector(
//             //         onTap: ()=>StoryScreen(snap: widget.snap[index]),
//             //         child: CircleAvatar(
//             //           radius: 40,
//             //           backgroundColor: Colors.white,
//             //         ),
//             //       ),
//             //     ),
//             //     Text('${widget.snap[index]['username']}',style: TextStyle(color: Colors.white),)
//             //   ],);},
//
//         ),
//
//     );
//   }
// }
