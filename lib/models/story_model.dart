import 'package:cloud_firestore/cloud_firestore.dart';

import 'user.dart';

class Story {
  final List<String> storyUrl;
  final DateTime duration;
  final String userId;
  final String username;
  final String storyId;

  Story(
      {required this.storyUrl,
      required this.duration,
      required this.userId,
      required this.username,
      required this.storyId});

  Map<String, dynamic> toJson() => {
        "storyUrl": storyUrl,
        "username": username,
        "userId": userId,
        "duration": duration,
        "storyId": storyId
      };

  static Story fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Story(
        storyUrl: snapshot['storyUrl'],
        username: snapshot['username'],
        userId: snapshot['userId'],
        duration: snapshot['duration'],
        storyId: snapshot['storyId']);
  }
}
