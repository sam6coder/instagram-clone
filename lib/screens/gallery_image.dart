import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';
import '../utils/image_grid.dart';
import 'package:image/image.dart' as img;
class GalleryImage extends StatefulWidget {
  const GalleryImage({super.key});

  @override
  State<GalleryImage> createState() => _GalleryImageState();
}

class _GalleryImageState extends State<GalleryImage> {
  List<AssetEntity>? galleryImages = [];
  List<File> selectedImage = [];
  late Future<Uint8List?> thumbNailFuture;




  Future<void> _fetchMedia() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> paths =
      await PhotoManager.getAssetPathList(type: RequestType.image|RequestType.video,);
      List<AssetEntity> media =
      await paths[0].getAssetListPaged(page: 0, size: 300);
      setState(() {
        galleryImages = media;
      });
    } else {
      PhotoManager.openSetting();
    }
  }




  @override
  void initState(){
  super.initState();
  _fetchMedia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text('Add to Story',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:20.0,bottom: 10),
            child: Row(
              children: [
                Text('Recents',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
                Icon(Icons.expand_more,color: Colors.white,)
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.8,
            child: galleryImages!.isNotEmpty
                ? GridView.builder(
              padding: EdgeInsets.all(2),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2),
              itemCount: galleryImages!.length,
              itemBuilder: (context, index) {
                return ImageGridItem(image: galleryImages![index], onTap: (){
                  print("indexx ${galleryImages![index].file}");
                  Navigator.of(context).pop(galleryImages![index]);
                }, width: 300, height: 600);

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
    );
  }
}
