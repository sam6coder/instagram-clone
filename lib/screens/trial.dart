// import 'package:flutter/material.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   final dummyData = [
//   {'username': 'Alice'},
// {'username': 'Bob'},
// {'username': 'Charlie'}];
//
// @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Container(
//             height: 300, // Provide sufficient height
//             child: PageView.builder(
//               controller: PageController(),
//               itemCount: dummyData.length,
//               onPageChanged: (index) {
//                 print("Page changed to: $index");
//               },
//               itemBuilder: (context, index) {
//                 print("Building widget for index: $index");
//                 return Center(
//                   child: Text(
//                     dummyData[index]['username']!,
//                     style: TextStyle(fontSize: 24, color: Colors.black),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// final dummyData = [
//   {'username': 'Alice'},
//   {'username': 'Bob'},
//   {'username': 'Charlie'},
// ];


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/story_screen.dart';
import 'package:instagram_clone/widgets/video_thumbnail.dart';

class TrialCard extends StatefulWidget {


  TrialCard({super.key});

  @override
  State<TrialCard> createState() => _TrialCardState();
}

class _TrialCardState extends State<TrialCard> {
  late PageController _pageController;


  @override
  void initState(){
    super.initState();
    _pageController=PageController();

  }
  final dummyData = [
    {'username': 'Alice'},
    {'username': 'Bob'},
    {'username': 'Charlie'},
  ];


  @override
  Widget build(BuildContext context) {
    // print("heyyyy ${widget.snap}");
    // print("len ${widget.snap.length}");
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height*0.15,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        controller: PageController(),
        itemCount: dummyData.length,
        itemBuilder:(context,index){
          print("index ${index}");
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: (){
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StoryScreen(snap: widget.snap[index])));
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              Text('${dummyData[index]['username']}',style: TextStyle(color: Colors.white),)
            ],);},

      ),

    );
  }
}
