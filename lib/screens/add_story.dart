import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}



class _AddStoryScreenState extends State<AddStoryScreen> {
  final ImagePicker picker = ImagePicker();
late CameraController _cameraController;
bool _isCameraInitialized=false;


@override
void initState(){
  super.initState();
  initializeCamera();
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


Future<CameraController> initializeCamera() async{
  final cameras=await availableCameras();
  _cameraController=CameraController(cameras[0], ResolutionPreset.high);
  await _cameraController.initialize();
  return _cameraController;
}

  Future<void> cameraPictures() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      // print(pickedFile.path);
      setState(() {
        // selectedImage?[0] = File(pickedFile.path);
        // selectedImage.add(File(pickedFile.path));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.85,
            child: FutureBuilder(future: initializeCamera(), builder: (context,snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return SizedBox(
                  height: 50,
                    width: 50,
                    child: CircularProgressIndicator());
              }else{
                return CameraPreview(_cameraController);
              }
            }),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.05,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom:10.0,left: 20,right: 20),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: mobileBackgroundColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    color: Colors.white,
                  ),
                  Center(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            child: Text(
                              'POST',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AddStoryScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              child: Text(
                                'STORY',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Icon(Icons.cameraswitch_outlined,color: Colors.white,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
