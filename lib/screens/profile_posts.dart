import 'package:flutter/material.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class ProfilePosts extends StatefulWidget {
  final snap;
  final int selectedIndex;
  ProfilePosts({required this.snap, required this.selectedIndex});

  @override
  State<ProfilePosts> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  late ScrollController _scrollController;

  @override
  void initState(){
    super.initState();
    _scrollController=ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _scrollController.jumpTo(widget.selectedIndex*400);
    });
  }

  @override
  void dipose(){
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: false,
        title: Text(
          'Posts',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemBuilder: (context, index) {
          return PostCard(snap: widget.snap[index]);
        },
        itemCount: widget.snap.length,
      ),
    );
  }
}
