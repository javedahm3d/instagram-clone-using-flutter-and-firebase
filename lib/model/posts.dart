import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String discription;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postURL;
  final String profileImage;
  final  likes;

  Post({
    required this.discription,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postURL,
    required this.profileImage,
    required this.likes,
  });


static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      discription: snapshot["discription"],
      uid: snapshot["uid"],
      username: snapshot["username"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      postURL: snapshot["postURL"],
      profileImage: snapshot["profileImage"],
      likes: snapshot["likes"],
    );
  }

  Map<String, dynamic> toJason() => {
        'discription': discription,
        'uid': uid,
        'username': username,
        'postId': postId,
        'datePublished': datePublished,
        'postURL': postURL,
        'profileImage': profileImage,
        'likes': likes,
      };
}
