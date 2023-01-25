import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone1/model/posts.dart';
import 'package:instagram_clone1/model/user.dart';
import 'package:instagram_clone1/provider/user_provider.dart';
import 'package:instagram_clone1/resources/storage_methods.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String discription,
    String uid,
    Uint8List? file,
    String username,
    String profileImage,
  ) async {
    String res = "some error occured";
    try {
      //storing post image in firebasestorage
      String photoUrl =
          await StorageMethod().uploadImageToStorage('posts', file!, true);

      //generating unique postid using uuid
      String postId = const Uuid().v1();

      Post post = Post(
          discription: discription,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postURL: photoUrl,
          profileImage: profileImage,
          likes: []);

      //storing to firebasefirestore
      firebaseFirestore.collection('posts').doc(postId).set(
            post.toJason(),
          );
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {

      if (likes.contains(uid)) {
        await firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String comment, String uid,
      String username, String profileImage) async {
    String res = 'some error occured';
    try {
      if (comment.isNotEmpty) {
        String commentId = const Uuid().v1();
        await firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'postId': postId,
          'commentId': commentId,
          'profileImage': profileImage,
          'username': username,
          'uid': uid,
          'date': DateTime.now(),
          'comment': comment,
          'likes': [],
        });
        res = 'posted!';
      } else {
        res = "please enter your comment";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

//like comment

  Future<void> likeComment(
      String postId, String commentId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //delete post

  Future<String> deletePost(String postId) async {
    String res = 'some error occured';
    try {
      await firebaseFirestore.collection('posts').doc(postId).delete();
      res = 'deleted';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
