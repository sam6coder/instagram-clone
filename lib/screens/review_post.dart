import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:instagram_clone/screens/post_screen.dart';
import 'dart:io';
import 'package:instagram_clone/utils/utils.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

import '../widgets/video_player.dart';


class ReviewPostScreen extends StatefulWidget {
  final List<File> selectedImages;

  const ReviewPostScreen({required this.selectedImages});

  @override
  State<ReviewPostScreen> createState() => _ReviewPostScreenState();
}

class _ReviewPostScreenState extends State<ReviewPostScreen> {
  CroppedFile? _croppedFile;
  File? editedImage;

  ScrollController scrollController=ScrollController();

  int currentIndex=0;


  Future<Uint8List> convertImageToUint8List(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return Uint8List.fromList(bytes);
  }
  void verifyImageDimensions(Uint8List data) {
    final decodedImage = img.decodeImage(data);
    if (decodedImage != null) {
      print('Image dimensions: ${decodedImage.width}x${decodedImage.height}');
    } else {
      print('Failed to decode image');
    }
  }

  Uint8List resizeImage(Uint8List data, double width, double height) {
    final originalImage = img.decodeImage(data);
    if (originalImage == null) throw Exception('Failed to decode image');
    print("width $width height $height");
    final resizedImage = img.copyResize(originalImage, width: width.toInt(), height: height.toInt());
    return Uint8List.fromList(img.encodeJpg(resizedImage));
  }

  // Future<CroppedFile?> croppedImage({required BuildContext context, required File imageFile}) async {
  //
  //   final _croppedFile = await ImageCropper().cropImage(
  //     sourcePath: imageFile.path,
  //     // compressQuality: 90,
  //
  //     // cropStyle: CropStyle.rectangle, // Choose rectangle or circle
  //     // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // Example: Square aspect ratio
  //
  //     uiSettings: [
  //       AndroidUiSettings(
  //         // toolbarTitle: 'Crop Image',
  //         // toolbarColor: Colors.blue,
  //         // toolbarWidgetColor: Colors.white,
  //         hideBottomControls: false, // Show the crop controls
  //         lockAspectRatio: false,
  //         showCropGrid: true,
  //         toolbarTitle: 'Crop Image',
  //         toolbarWidgetColor: Colors.white,
  //         toolbarColor: Colors.blue,
  //
  //
  //         aspectRatioPresets: [
  //           CropAspectRatioPreset.original,
  //           CropAspectRatioPreset.square,
  //           CropAspectRatioPreset.ratio4x3,
  //           CropAspectRatioPreset.ratio16x9,
  //
  //           // CropAspectRatioPresetCustom(),
  //         ],
  //       ),
  //       IOSUiSettings(
  //         title: 'Crop Image',
  //         aspectRatioPresets: [
  //           CropAspectRatioPreset.original,
  //           CropAspectRatioPreset.square,
  //           CropAspectRatioPreset.ratio4x3,
  //           CropAspectRatioPreset.ratio16x9,
  //
  //           // CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
  //         ],
  //
  //       ),
  //     ],
  //   );
  //
  //
  //
  //
  //   // Use the cropped file here
  //   return _croppedFile;
  // }



  @override
  void initState(){
    scrollController.addListener(updateCurrentIndex);

  }

  @override
  void dispose(){
    scrollController.removeListener(updateCurrentIndex);
    scrollController.dispose();
    super.dispose();
  }

  void updateCurrentIndex(){
    double offset=scrollController.offset;
    double viewPortWidth =MediaQuery.of(context).size.width;
    int newIndex=(offset/viewPortWidth).round();

    if(newIndex!=currentIndex){
      setState(() {
        currentIndex=newIndex;
      });
    }
  }


  // Future<void> updateCropped(File file) async{
  //   final croppped=await croppedImage(context: context, imageFile: file);
  //   print(croppped!.path);
  //   if(croppped!=null)
  //     setState(() {
  //
  //       _croppedFile=croppped;
  //
  //     });
  //
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: (){
                setState(() {
                  Navigator.of(context).pop();
                });
              },
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left:3.0,top:30),
                  child: Container(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.close,size: 30,),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(itemCount: widget.selectedImages.length+1,
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,

                  itemBuilder:(context, index) {

                    if(index==widget.selectedImages.length){
                      return Padding(
                        padding: EdgeInsets.all(20),
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            // height: 50,
                            // width: 50,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              // borderRadius: BorderRadius.circular(50.0),
                              border: Border.all(color: Colors.white),
                            ),
                            child: CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.black,
                                child: Icon(Icons.add,size: 45,color: Colors.white,)),
                          ),
                        ),
                      );
                    }else{
                      return Container(
                        height: 300,
                        child: Row(
                          children: [
                            Stack(
                              children:[ Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                    height: 300,
                                    decoration: BoxDecoration(shape: BoxShape.rectangle,borderRadius: BorderRadius.circular(12),border: Border.all(color: Colors.grey,width: 1)),
                                    clipBehavior: Clip.hardEdge,
                                    child: (_croppedFile==null)?(widget.selectedImages[index].path.endsWith('.mp4'))?SizedBox
                                      (height: double.infinity,
                                        width:MediaQuery.of(context).size.width*0.98 ,

                                        child: VideoThumbnail(file: widget.selectedImages[index],)):
                                    Image.file(
                                      widget.selectedImages[index],
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width * 0.98,
                                      height: double.infinity,
                                    ):Image.file(
                                      File(_croppedFile!.path),
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width * 0.98,
                                      height: double.infinity,
                                    )),
                              ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child : GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        widget.selectedImages.removeAt(index);
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                          height: 25,
                                          width: 25,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,

                                          ),
                                          child: CircleAvatar(
                                              backgroundColor: Colors.transparent,
                                              radius: 5,
                                              child: Icon(Icons.close,color: Colors.grey,size: 20,))),
                                    ),
                                  ),
                                ),
                           ], ),




                          ],
                        ),
                      );
                    }
                  }),

                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        Navigator.pop(context);

                      });

                    },
                    child: Container(
                      height: 50,
                      width: 60,
                      decoration: BoxDecoration(shape: BoxShape.rectangle,borderRadius: BorderRadius.circular(12),color:Color(0xFF2B3036),border: Border.all(width: 1)),
                      child: Icon(Icons.image),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: (){
                  //     setState(() {
                  //       updateCropped(widget.selectedImages[currentIndex]);
                  //       // Navigator.push(
                  //       //   context,MaterialPageRoute(builder: (context)=>ImageCropperScreen(selectedImage: widget.selectedImages[currentIndex],))
                  //       // );
                  //
                  //     });
                  //
                  //   },
                  //   child: Container(
                  //     height: 50,
                  //     width: 60,
                  //     decoration: BoxDecoration(shape: BoxShape.rectangle,borderRadius: BorderRadius.circular(12),color:Color(0xFF2B3036),border: Border.all(width: 1)),
                  //     child: Icon(Icons.crop),
                  //   ),
                  // ),

                    GestureDetector(

                    onTap: () async{
                      final imageData=await convertImageToUint8List (widget.selectedImages[currentIndex]);
                      verifyImageDimensions(imageData);
                      final imgData=resizeImage(imageData, MediaQuery.of(context).size.width*2.4, MediaQuery.of(context).size.height);
                      final imgd=await send(context: context,data: imgData);
                      setState(() {
                        widget.selectedImages[currentIndex]=imgd!;
                      });


                    },
                    child: Container(
                      height: 50,
                      width: 60,
                      decoration: BoxDecoration(shape: BoxShape.rectangle,borderRadius: BorderRadius.circular(12),color:Color(0xFF2B3036),border: Border.all(width: 1)),
                      child: Icon(Icons.colorize_sharp),
                    ),
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:20.0,bottom: 10,right: 20),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 50,
                  width: 110,
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
                        borderRadius: BorderRadius.circular(32.0),
                        side: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        Text(
                          'Next',
                          style: const TextStyle(fontSize: 17, color: Colors.white),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,size: 20,color: Colors.white,
                        )
                      ],
                    ),
                    onPressed: () {
                      bool isMulti=(widget.selectedImages.length==1)?false:true;
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen(selectedImages: widget.selectedImages,isMultiSelect:isMulti ,)));                    },
                  ),
                ),
              ),
            ),


          ],
        ),
    );
  }
}
