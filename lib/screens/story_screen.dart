import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:video_player/video_player.dart';

import '../models/story_model.dart';
import '../widgets/video_thumbnail.dart';

class StoryScreen extends StatefulWidget {
  final snap;
  final VoidCallback onComplete;

  const StoryScreen({required this.snap,required this.onComplete});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final StoryController storyController=StoryController();


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

  Future<List<StoryItem>> buildStoryItems(List<String> urls) async{
    List<StoryItem> storyItems=[];
    for(String url in urls){
      String fileType=await checkFileType(url);
      if(fileType=="video"){
        Duration videoDur=await _getVideoDuration(url);
        storyItems.add(
          StoryItem.pageVideo(url, controller: storyController,duration:videoDur));
    }else if(fileType=="image"){
        storyItems.add(
          StoryItem.pageImage(url: url, controller: storyController)
        );
        }
      }
      return storyItems;
  }
  Future<Duration> _getVideoDuration(String videoUrl) async {
    final VideoPlayerController videoPlayerController =
    VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    await videoPlayerController.initialize();
    final Duration duration = videoPlayerController.value.duration;
    videoPlayerController.dispose();
    return duration;
  }


  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final storyController=StoryController();
    final story=Story.fromSnap(widget.snap.data() as Map<String,dynamic>);
    
    return FutureBuilder(future: buildStoryItems(story.storyUrl),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(color: Colors.white,),);
          }
          if(snapshot.hasError){
            return Center(child: Text("Story not available"),);
          }
          return StoryView(storyItems: snapshot.data!,
            controller: storyController,
            onComplete: widget.onComplete,

            onVerticalSwipeComplete: (direction){
            if(direction==Direction.down
              )
              Navigator.pop(context);
            },

          );
        });
    // return StoryView(
    //   storyItems: story.storyUrl.map((url){
    //     // if(checkFileType(url)=="Video")
    //     return StoryItem.pageImage(url: url, controller: storyController);
    //
    //   }).toList(),
    //   controller: storyController,
    //   onComplete: widget.onComplete,
    //   onVerticalSwipeComplete: (direction){
    //     if(direction==Direction.down){
    //       Navigator.pop(context);
    //     }
    //   },
    // );
    // return Stack(
    //     children: [
    //       SizedBox(
    //         height: MediaQuery.of(context).size.height,
    //         width: MediaQuery.of(context).size.width,
    //         child: FutureBuilder(
    //             future: checkFileType(widget.snap['storyUrl'][0]),
    //             builder: (context, snapshot) {
    //               if (snapshot.connectionState == ConnectionState.waiting) {
    //                 return Transform.scale(
    //                     scaleY: 0.1,
    //                     scaleX: 0.07,
    //                     child: CircularProgressIndicator(
    //                       color: Colors.white,
    //                       strokeWidth: 6,
    //                     ));
    //               } else if (snapshot.hasError) {
    //                 // Handle any errors from the async function
    //                 return Text('Error: ${snapshot.error}');
    //               } else if (snapshot.data=="image") {
    //                 return Image.network(widget.snap['storyUrl'][0]);
    //               }else if(snapshot.data=="video"){
    //                 return VideoPlayerScreen(videoUrl: widget.snap['storyUrl'][0]);
    //               }
    //               return Text("Story not available");
    //             }),
    //       ),
    //     ],
    //   );

  }
}
