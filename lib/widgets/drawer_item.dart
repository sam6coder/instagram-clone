import 'package:flutter/material.dart';

Widget buildDrawerItem(IconData icon, String label,BuildContext context,Color col,VoidCallback onTapp){
  return Padding(
    padding: const EdgeInsets.only(left:20.0,top:50),
    child: ListTile(
      onTap:onTapp,
      title: Text(label,style: TextStyle(color: Colors.white,fontSize: 25),),
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon,color: col,size: 34,),
          // if(badge!=null)
          //   Positioned
          //     (
          //     right: -6,
          //       top: -2,
          //       child: Container(
          //     decoration: BoxDecoration(
          //       color: Colors.red,
          //       shape: BoxShape.circle,
          //     ),
          //     padding: EdgeInsets.all(4),
          //   )),

        ],

      ),
    ),
  );
}