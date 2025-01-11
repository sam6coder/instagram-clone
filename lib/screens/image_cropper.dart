import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';


class ImageCropperScreen extends StatefulWidget {
  final File selectedImage;

  ImageCropperScreen({required this.selectedImage});
  @override
  State<ImageCropperScreen> createState() => _ImageCropperScreenState();
}

class _ImageCropperScreenState extends State<ImageCropperScreen> {
  CroppedFile? _croppedFile;


  Future<CroppedFile?> _cropImage(BuildContext context, File imageFile) async {
    // print(imageFile.path);

     _croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      // compressQuality: 90,

      // cropStyle: CropStyle.rectangle, // Choose rectangle or circle
      // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // Example: Square aspect ratio

      uiSettings: [
        AndroidUiSettings(
          // toolbarTitle: 'Crop Image',
          // toolbarColor: Colors.blue,
          // toolbarWidgetColor: Colors.white,
          hideBottomControls: false, // Show the crop controls
          lockAspectRatio: false,
          showCropGrid: true,
          toolbarTitle: 'Crop Image',
          toolbarWidgetColor: Colors.white,
          toolbarColor: Colors.blue,


          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,

            // CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,

            // CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
          ],

        ),
      ],
    );



    if (_croppedFile != null) {
      // print(_croppedFile!.path);
      // Use the cropped file here
      return _croppedFile;
    }
  }


  @override
  void initState(){
    _cropImage(context, widget.selectedImage);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Cropper'),
        centerTitle: false,
        actions: [Padding(
          padding: const EdgeInsets.only(right:15.0),
          child: GestureDetector(onTap: (){Navigator.pop(context,File(_croppedFile!.path));}, child: Text('Done',style: TextStyle(color: Colors.blue,fontSize: 20),),),
        )],
      ),
      body: Center(
        child: Stack(
          children:[
            Positioned(
              bottom: 50,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                color: Colors.blue,

              ),
            ),

              if(_croppedFile!=null)
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  // color: Colors.blue,
                  child: Image.file(
                    File(_croppedFile!.path),
                    cacheWidth: 600,

                    fit: BoxFit.cover,
                  ),
                )
              else
                Image.file(
                  File(widget.selectedImage.path),
                  height: 300,
                  width: MediaQuery.of(context).size.width,

                  fit: BoxFit.cover,
                )


            ],
          ),
        ),

    );
  }
}




