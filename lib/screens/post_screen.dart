import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/add_location.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screeen.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'dart:typed_data';
import 'package:instagram_clone/models/user.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/video_player.dart';

class PostScreen extends StatefulWidget {
  final List<File> selectedImages;
  final bool isMultiSelect;
  const PostScreen({required this.selectedImages, required this.isMultiSelect});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool isLoading=false;
  List<Uint8List> _files=[];

  TextEditingController captionController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  String location = '';
  List<String> words = [];

  void postImage(String uid, String username, String profImage,List<Uint8List> _file,String name) async {
    setState(() {
      isLoading=true;
    });
    try {
        String res=await  FireStoreMethods().uploadPost(captionController.text, _files,uid,username, profImage, location,name);
        if(res=="success"){
          setState(() {
            isLoading=false;
          });
          showAlertToast(msg: 'Posted', color: Colors.green);

          Navigator.push(context, MaterialPageRoute(builder: (context)=>FeedScreen()));

        }else{
          setState(() {
            isLoading=false;
          });
          showAlertToast(msg: res, color: Colors.pink);
        }
    } catch (e) {
      showAlertToast(msg: e.toString(), color: Colors.pink);
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user=Provider.of<UserProvider>(context).getUser;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'New Post',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.black,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                isLoading?LinearProgressIndicator():Padding(padding: EdgeInsets.only(top:0),),
                Divider(),
                widget.isMultiSelect
                    ? Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.22,
                          child: ListView.builder(
                              itemCount: widget.selectedImages.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: (widget.selectedImages[index].path
                                          .endsWith('.mp4'))
                                      ? SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                      height: MediaQuery.of(context).size.height * 0.22,

                                      child: VideoThumbnail(
                                            file: widget.selectedImages[index],
                                          ))
                                      : Image.file(
                                          widget.selectedImages[index],
                                          fit: BoxFit.cover,
                                        ),
                                );
                              }),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.22,
                        child: (widget.selectedImages[0].path.endsWith('.mp4'))
                            ? SizedBox(
                                height: double.infinity,
                                child: VideoThumbnail(
                                  file: widget.selectedImages[0],
                                ))
                            : Image.file(
                                widget.selectedImages[0],
                                fit: BoxFit.cover,
                              )),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: captionController,
                    decoration: InputDecoration(
                      hintText: "Add a caption...", // Hint text here
                      hintStyle:
                          TextStyle(color: Colors.grey), // Optional styling
                      border: InputBorder
                          .none, // Remove the border for a clean look
                    ),
                    style: TextStyle(fontSize: 18), // Custom styling if needed
                    maxLines: null, // Allow multiline input
                    cursorColor: Colors.blue,
                  ),
                ),
                Divider(
                  thickness: 0.15,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () async {
                      final loc = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddLocation()));
                      setState(() {
                        if (loc != null) {
                          location = loc;
                          words = location.split(',');
                        }
                      });
                    },
                    child: Container(
                      child: (location == '')
                          ? Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  'Add Location',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                  width: 7,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                          "${words[0]}",
                                          style: TextStyle(
                                              color: Colors.blue, fontSize: 17),
                                        ),
                                      // if (words[2].isNotEmpty &&
                                      //     words[3].isNotEmpty)
                                      //   Text(
                                      //     "${words[2]}, ${words[3]}",
                                      //     style: TextStyle(
                                      //         color: Colors.grey, fontSize: 15),
                                      //   ),
                                      if (words.length>1)
                                        Text(
                                          "${words[1]}",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 15),
                                        ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        location = '';
                                      });
                                      final loc = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddLocation()));
                                      setState(() {
                                        if (loc != null) {
                                          location = loc;
                                          words = location.split(',');
                                        }
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ))
                              ],
                            ),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(5),
                      backgroundColor: Colors.blue,
                      visualDensity: VisualDensity.standard,
                      elevation: 5.0,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    child: Text(
                      'Share',
                      style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async{
                      setState(() {

                      });
                      for(int i=0;i<widget.selectedImages.length;i++) {
                        final bytes = await widget.selectedImages[i]
                            .readAsBytes();
                        _files.add(bytes);
                        // print("first : $bytes");

                      }

                        postImage(
                            user.uid, user.username, user.photoUrl, _files,user.name);

                    },
                  ),
                )
              ],
            )));
  }
}
