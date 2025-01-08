import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:path_provider/path_provider.dart';

pickImage(ImageSource source)async{
  final ImagePicker _imagePicker=ImagePicker();
  XFile? file=await _imagePicker.pickImage(source: source);

  if(file!=null){
    return file.readAsBytes();
  }
  print("no image selected");
}

showSnackBar(String content,BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content),)
  );
}

Future<bool?>  showAlertToast({required String msg,required Color color}) {
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}

showLoaderDialog(
    {required BuildContext context, required String loaderMessage}) {
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    content: PopScope(
      canPop: false,
      child: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Text(loaderMessage),
          ),
        ],
      ),
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog(
    {required BuildContext context,
      required String titleText,
      required String alertMessage,
      required String text,
      Icon? alertIcon,
      Widget? button}) {
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    title: Row(
      children: [
        alertIcon ?? Container(),
        const SizedBox(width: 10),
        Expanded(child: Text(titleText)),
      ],
    ),
    content: Text(
      alertMessage,
      style: const TextStyle(
        fontSize: 15,
      ),
    ),
    actions: [
      button ?? Container(),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("Cancel"),
      ),
    ],
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<File?> send({required BuildContext context,required Uint8List data}) async{
  final editedImage = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ImageEditor(
        image: data, // <-- Uint8List of image

      ),
    ),
  );
  final tempDir = await getTemporaryDirectory();
  final tempPath = '${tempDir.path}/edited_image_${DateTime.now().millisecondsSinceEpoch}.png';
  final editedFile = File(tempPath);
  await editedFile.writeAsBytes(editedImage.buffer.asUint8List());
  return editedFile;


}

// Future<Uint8List?> convertVideoToUint8List(String videoPath) async {
//   try {
//     final thumbnail = await VideoThumbnail.thumbnailData(
//       video: videoPath,
//       imageFormat: ImageFormat.JPEG,
//       maxHeight: 300, // Specify height for the thumbnail
//       quality: 75,   // Specify quality of the thumbnail
//     );
//     return thumbnail;
//   } catch (e) {
//     print('Error generating video thumbnail: $e');
//     return null;
//   }
// }
//
//
//
//
