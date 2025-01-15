import 'package:flutter/material.dart';

class StoryCard extends StatefulWidget {
   StoryCard({super.key});

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
          ),
        ),
        Text('name',style: TextStyle(color: Colors.white),)
      ],
    );
  }
}
