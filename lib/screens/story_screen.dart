import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/video_thumbnail.dart';

class StoryScreen extends StatefulWidget {
  final snap;
  const StoryScreen({required this.snap});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
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
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
                future: checkFileType(widget.snap['storyUrl'][0]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                  } else if (snapshot.data=="image") {
                    return Image.network(widget.snap['storyUrl'][0]);
                  }else if(snapshot.data=="video"){
                    return VideoPlayerScreen(videoUrl: widget.snap['storyUrl'][0]);
                  }
                  return Text("Story not available");
                }),
          ),
        ],
      );

  }
}
