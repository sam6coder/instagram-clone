import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;


  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;

        }); // Refresh the UI once video is initialized
        _controller.play(); // Start video playback
      }).catchError((error) {
        debugPrint("Video Player Error: $error");
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:_togglePlayPause ,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _isInitialized
              ? VideoPlayer(_controller) // Display video player thumbnail
              : Center(child: CircularProgressIndicator()),
          if(!_isPlaying)
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 40,
              ),
            ),// Show loading spinner

        ],
      ),
    );
  }
}
