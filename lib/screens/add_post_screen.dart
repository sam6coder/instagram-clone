import 'dart:io';
import 'package:instagram_clone/screens/add_story.dart';
import 'package:instagram_clone/widgets/video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/screens/review_post.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/image_grid.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:photo_manager/photo_manager.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool isChecked = false;
  List<bool> isCheckedList = [];
  List<AssetEntity>? galleryImages = [];
  final ImagePicker picker = ImagePicker();
  List<File> selectedImage = [];
  bool isMultiSelect = false;
  Color color = Colors.grey;

  @override
  void initState() {
    super.initState();
    _fetchMedia();
    // cameraPictures();
  }

  Future<void> _fetchMedia() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> paths =
          await PhotoManager.getAssetPathList(type: RequestType.image|RequestType.video,);
      List<AssetEntity> media =
          await paths[0].getAssetListPaged(page: 0, size: 300);
      setState(() {
        galleryImages = media;
        isCheckedList = List<bool>.filled(galleryImages!.length, false);
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  Future<void> cameraPictures() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      // print(pickedFile.path);
      setState(() {
        // selectedImage?[0] = File(pickedFile.path);
        selectedImage.add(File(pickedFile.path));
      });
    }
  }

  // _selectImage(BuildContext context) async{
  //   return showDialog(context: context, builder:(context){
  //     return SingleDialog
  //   });
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        title: Text('New Post'),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () async{
                if(selectedImage.length==0)
                  showAlertToast(msg: 'Select an image', color: Colors.pink);
                else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ReviewPostScreen(selectedImages: selectedImage)));                  // final updatedImage = await Navigator.pushNamed(
                  //     context, '/imageSelector',
                  //     arguments: selectedImage) as List<File>?;
                  // if(updatedImage!=null){
                  //   setState(() {
                  //     selectedImage=updatedImage;
                  //   });
                  // }
                }
              },
              child: Text(
                'Next',
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ))
        ],
      ),
      body: Stack(

        children:[ Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.black,
                width: double.infinity,
                child: selectedImage.isNotEmpty
                    ?(selectedImage[selectedImage.length-1].path.endsWith('.mp4'))?VideoThumbnail(file: selectedImage[selectedImage.length-1],): Image.file(
                        selectedImage[selectedImage.length - 1],
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Text(
                          'No image selected',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            Container(
              color: Colors.black,
              width: MediaQuery.of(context).size.width,
              height: 44,
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recents',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isMultiSelect = !isMultiSelect;
                                if (!isMultiSelect) {
                                  isCheckedList = List<bool>.filled(
                                      galleryImages!.length, false);
                                  selectedImage.clear();
                                  color = Colors.grey;
                                } else {
                                  color = Colors.blue;
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: color,
                              child: Icon(
                                Icons.collections_bookmark_sharp,
                                size: 17,
                              ),
                              radius: 13,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                              onTap: () => cameraPictures(),
                              child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 17,
                                  ),
                                  radius: 13)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: galleryImages!.isNotEmpty
                  ? GridView.builder(
                      padding: EdgeInsets.all(2),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2),
                      itemCount: galleryImages!.length,
                      itemBuilder: (context, index) {
                        return ImageGridItem(
                            image: galleryImages![index],
                            isChecked: isCheckedList[index],
                            onTap:() async {
                              final _file = await galleryImages![index].file;
                              setState(() {
                                if(isMultiSelect) {
                                  isCheckedList[index] = !isCheckedList[index];
                                  print("yessss ${selectedImage.length}");

                                  if (isCheckedList[index]) {
                                    selectedImage.add(_file!);
                                  }
                                  if (!isCheckedList[index]) {
                                    // selectedImage.remove(file);
                                    selectedImage.removeWhere((file) => file.toString() == _file.toString());

                                    print("no ${selectedImage.length}");
                                  }
                                }else{
                                  selectedImage.clear();
                                  if(!isCheckedList[index])
                                  isCheckedList=List<bool>.filled(isCheckedList.length,false);
                                  isCheckedList[index]=!isCheckedList[index];
                                  if(isCheckedList[index])
                                    selectedImage.add(_file!);
                                  else
                                  selectedImage.clear();
                                }



                              });
                            });
                      },
                    )
                  : Center(
                      child: Text(
                        'No images found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
          ],
        ),
          Positioned(
            bottom: 50,
            left: 200,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF2B3036),
                borderRadius: BorderRadius.circular(20),
              ),
            width: 50,
            height:50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    child: Text('POST',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddStoryScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      child: Text('STORY',style: TextStyle(fontSize: 20,color: Colors.grey,fontWeight: FontWeight.bold),),
                    ),
                  ),
                )
              ],
            ),
          ),

          )
     ], ),
      // body: Column(
      //   children: [
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       crossAxisAlignment: CrossAxisAlignment.start ,
      //       children: [
      //         CircleAvatar(
      //            backgroundImage:NetworkImage() ,
      //         ),
      //         SizedBox(
      //           width: MediaQuery.of(context).size.width*0.3,
      //           child:TextField(
      //             decoration: InputDecoration(
      //               hintText: 'Write a caption .',border: InputBorder.none
      //             ),
      //             maxLines: 8,
      //           ),
      //         ),
      //         SizedBox(
      //           height: 45,
      //           width: 45,
      //           child: AspectRatio(aspectRatio: 487/451,child: Container(
      //             decoration: BoxDecoration(
      //
      //             ),
      //           ),),
      //         )
      //       ],
      //     )
      //   ],
      // ),
    );
    // return Center(
    //   child: IconButton(onPressed: onPressed, icon: Icon(Icons.upload)),
    // );
  }
}
