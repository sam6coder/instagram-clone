import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageGridItem extends StatefulWidget {
  final AssetEntity image;
  final bool? isChecked;
  final VoidCallback onTap;
  final int width;
  final int height;
  const ImageGridItem({
    Key? key,
    required this.image,
    this.isChecked,
    required this.onTap,
    required this.width,
    required this.height
});

  @override
  State<ImageGridItem> createState() => _ImageGridItemState();
}

class _ImageGridItemState extends State<ImageGridItem> {
  late Future<Uint8List?> thumbNailFuture;

  @override
  void initState(){
    super.initState();
    thumbNailFuture=widget.image.thumbnailDataWithSize(ThumbnailSize(widget.width,widget.height));

  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>
      (future: thumbNailFuture,
        builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return Container(
            color: Colors.grey,
            child: Center(child: CircularProgressIndicator(),),
          );
        }
        if(!snapshot.hasData || snapshot.data==null){
          return Container(
            color: Colors.grey,
            child: Center(child: Text('No images found'),),
          );}

          return GestureDetector(
            onTap: widget.onTap,
            child: Stack(
              children: [
                Image.memory(
                  snapshot.data!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                if(widget.isChecked!=null)
                Positioned(
                    bottom: 8,
                    right: 8,

                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white
                        )
                      ),

                      child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.transparent,

                          child: (widget.isChecked!)?Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                            size: 18,
                          ):null),
                    ))
              ],
            ),
          );

    });
  }
}

