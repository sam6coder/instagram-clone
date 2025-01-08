import 'package:flutter/material.dart';


class LikesSliderPage extends StatelessWidget {
  // Sample list of users who liked the post
  final List<dynamic> likes;
  LikesSliderPage({required this.likes});

  @override
  Widget build(BuildContext context) {
    bool _isSheetVisible=true;

        return Stack(
          children:[ GestureDetector(
            onTap: (){
              Navigator.of(context).pop();

            },
    child: Container(color: Colors.black.withOpacity(0.5),
    ),),
            DraggableScrollableSheet(
                initialChildSize: 0.7, // Start with half screen
                minChildSize: 0, // Minimum screen size when dragged down
                maxChildSize: 1, // Maximum screen size when dragged up
                builder: (BuildContext context,ScrollController scrollController) {
                  return Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF25282D),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Drag handle
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Likes",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: likes.length,
                              itemBuilder: (context, index) {
                                final user = likes[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Text(
                                      user,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  title: Text(
                                    user,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    user,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );}
            ),

        ],);


  }
}
