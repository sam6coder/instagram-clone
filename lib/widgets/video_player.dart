import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnail extends StatefulWidget {
  final File file;

  VideoThumbnail({required this.file});

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;


  @override
  void initState() {
    super.initState();

    // Initialize the video player
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
      });
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
  void dispose() {
    _controller.dispose();
    super.dispose();
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

        ],
      ),
    );
  }
}
