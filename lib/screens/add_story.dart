import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screeen.dart';
import 'package:instagram_clone/screens/gallery_image.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widgets/video_player.dart';


class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {

  final ImagePicker picker = ImagePicker();
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  int selectedCameraIndex = 0;
  // bool isCaptured=false;
  String? _capturedImagePath;
  List<Uint8List> files=[];
  bool isLoading=false;bool cameraCaptured=false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
    final user = Provider.of<UserProvider>(context,listen: false);
    user.refreshUser();
  }
  //



  void postImage(String uid,String username,List<Uint8List> files,String photoUrl) async{
    setState(() {
      isLoading=true;
    });
    showSnackBar('Posting...', context);
    try{
      String res=await FireStoreMethods().uploadStory(uid, username, files,photoUrl);
      if(res=="Success") {
        setState(() {
          isLoading = false;
        });showAlertToast(msg: "Story uploaded successfully", color: Colors.green);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>FeedScreen()));
      }else{
        setState(() {
          isLoading=false;
        });
        showAlertToast(msg: res, color: Colors.pink);
      }
    }catch(e){
      showAlertToast(msg: e.toString(), color: Colors.pink);
    }
  }
  IconData getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
    }
    // This enum is from a different package, so a new value could be added at
    // any time. The example should keep working if that happens.
    // ignore: dead_code
    return Icons.camera;
  }


  // Future<String> addStory() async{
  //   await FireStoreMethods().uploadStory(userId, username, storyId, files)
  // }

  void switchCamera() async {
    final cameras = await availableCameras();
    setState(() {
      selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
      _isCameraInitialized = false;
    });

    _cameraController.dispose();
    initializeCamera();
  }

  Future<void> captureImage() async {
    try {
      if (_isCameraInitialized) {
        final XFile image = await _cameraController.takePicture();
        setState(() {
          _capturedImagePath = image.path;
          cameraCaptured=true;
        });
      }
    } catch (e) {
      showAlertToast(msg: e.toString(), color: Colors.pink);
    }
  }


  void initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController =
        CameraController(cameras[selectedCameraIndex], ResolutionPreset.high);
    await _cameraController.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  @override

  void dispose(){
    _capturedImagePath=null;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    print("camers ${_capturedImagePath}");
    final UserModel user = Provider.of<UserProvider>(context).getUser;
    final height=MediaQuery.of(context).size.height;

    return Scaffold(
        body: _isCameraInitialized
            ? Stack(
                children: [
                  // if(cameraCaptured==false && _capturedImagePath!=null)
                  //   Positioned(top:0,child: Container(height: MediaQuery.of(context).size.height*0.4)),
                  Center(
                    child: Container(
                        height:(_capturedImagePath!=null)?(cameraCaptured==false)? MediaQuery.of(context).size.height * 0.3:MediaQuery.of(context).size.height * 0.85:MediaQuery.of(context).size.height * 0.85,
                        child: (_capturedImagePath != null)?(_capturedImagePath!.endsWith('.mp4'))
                            ? VideoThumbnail(file: File(_capturedImagePath!)):Image.file(File(_capturedImagePath!))
                            : Center(child: CameraPreview(_cameraController))),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                    ),
                  ),
                  if(_capturedImagePath==null)
                  Positioned(
                    bottom: 30,
                    right:30,
                    child: IconButton(onPressed: ()=>switchCamera(), icon: Icon(Icons.cameraswitch_outlined,size: 40,color: Colors.white,))
                  ),

                  if(_capturedImagePath==null)
                    Positioned(
                      left: 20,
                      bottom: 30,
                      child: GestureDetector(
                        onTap: () async{
                          setState(() {
                            _capturedImagePath=null;
                          });
                          final imge=await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GalleryImage()));

                          File rf=await imge.file;

                          print("rff ${rf.path}");
                          if(!rf.path.endsWith('mp4')) {
                            final imageData = await convertImageToUint8List(rf);
                            verifyImageDimensions(imageData);
                            final imgData = resizeImage(imageData, MediaQuery
                                .of(context)
                                .size
                                .width, MediaQuery
                                .of(context)
                                .size
                                .height * 0.3);
                            int randomInt = Random().nextInt(100);
                            File imgd = await convertUint8ListToFile(
                                imgData, '${randomInt}');
                            // print(imgd.path);
                            setState(() {
                              _capturedImagePath = imgd.path;
                              cameraCaptured=false;
                            });
                          }else{
                            setState(() {
                              _capturedImagePath=rf.path;
                              cameraCaptured=false;

                            });
                          }
                          // print(_capturedImagePath);
                        },
                        child: Icon(Icons.image,color: Colors.white,size: 45,)
                      ),
                    ),


                  if (_capturedImagePath == null)
                    Positioned(
                      bottom: 100 - 20,
                      left: MediaQuery.of(context).size.width / 2 - 50,
                      child: GestureDetector(
                        onTap: () => captureImage(),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),

                  if(_capturedImagePath!=null)
                    Positioned(
                        bottom: 30,
                        left: MediaQuery.of(context).size.width / 2 - 70,
                        child: GestureDetector(
                          onTap: () async{
                            setState(() {
                              isLoading=true;
                            });
                            files.clear();
                            final img=File(_capturedImagePath!);
                            final bytes=await img.readAsBytes();
                            files.add(bytes);
                            postImage(user.uid, user.username,files ,user.photoUrl);

                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF2B3036),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: 150,
                            height:50,
                            child: Center(
                              child: Text(
                                'Your Story',style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )),
                  
                  if(_capturedImagePath==null)
                    Positioned(
                      bottom: 30,
                      left: MediaQuery.of(context).size.width/2-60,
                      
                      
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FeedScreen()));
                            },child: Text('POST',style: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.bold),)),
                            Text('STORY',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
                          ]
                        ),
                      ),
                    )
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                color: Colors.white,
              )));
  }
}
