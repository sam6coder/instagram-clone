import 'package:cloud_firestore/cloud_firestore.dart';

import 'user.dart';

class Story {
  final List<String> storyUrl;
  final DateTime duration;
  final String userId;
  final String username;
  final String storyId;
  final String photoUrl;

  Story(
      {required this.storyUrl,
      required this.duration,
      required this.userId,
      required this.username,
      required this.storyId,
      required this.photoUrl});

  Map<String, dynamic> toJson() => {
        "storyUrl": storyUrl,
        "username": username,
        "userId": userId,
        "duration": duration,
        "storyId": storyId,
    "photoUrl":photoUrl
      };

  factory Story.fromSnap(Map<String,dynamic> snapshot) {
    // var snapshot = snap.data() as Map<String, dynamic>;
    return Story(
        storyUrl: List<String>.from(snapshot['storyUrl']),
        username: snapshot['username'],
        userId: snapshot['userId'],
        duration: (snapshot['duration'] as Timestamp).toDate(),
        storyId: snapshot['storyId'],
    photoUrl: snapshot['photoUrl']);
  }
}
