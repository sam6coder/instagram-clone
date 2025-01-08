import 'package:flutter/material.dart';


class LikesSliderPage extends StatelessWidget {
  // Sample list of users who liked the post
  final List<dynamic> likes;
  LikesSliderPage({required this.likes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DraggableScrollableSheet(
          initialChildSize: 0.5, // Start with half screen
          minChildSize: 0.3, // Minimum screen size when dragged down
          maxChildSize: 1, // Maximum screen size when dragged up
          builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
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
        );}
      ),
    );
  }
}
